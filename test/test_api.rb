require 'config/boot'
require 'test/unit'
require 'model/release'

module Squirrel
  class ApiTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def app
      return @app unless @app.nil?
      app, options = Rack::Builder.parse_file(File.join(File.dirname(__FILE__), "..", "config.ru"))
      @app = app
    end

    def setup
      Release.load(File.join(File.dirname(__FILE__), 'fixtures', 'releases.json'))
      @release = Release.latest_release
    end

    def teardown
      Release.unload
    end

    def test_release_latest
      get '/updates/latest'

      # Response should be 200 without a version parameter
      assert last_response.ok?

      # Body should be parsable as JSON
      body = JSON.parse(last_response.body)
      assert body

      # The only required property is url
      assert body['url']
    end

    def test_time_is_iso8601
      get '/updates/latest'

      body = JSON.parse(last_response.body)

      # If pub_date is present, it must be parsable as ISO 8601
      if pub_date = body['pub_date']
        assert DateTime.iso8601(pub_date)
      end
    end

    def test_version_match_yields_204
      get "/updates/latest?v=#{@release.version}"

      assert_equal 204, last_response.status
    end

    def test_expected_types
      get '/updates/latest'

      body = JSON.parse(last_response.body)

      url = body['url']
      assert url.is_a? String

      if name = body['name']
        assert name.is_a? String
      end

      if notes = body['notes']
        assert notes.is_a? String
      end

      if pub_date = body['pub_date']
        assert pub_date.is_a? String
      end
    end

  end
end
