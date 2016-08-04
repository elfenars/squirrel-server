require 'app/model/release'

module Squirrel
  class Api < Sinatra::Base

    set :logging, true

    get '/updates/latest' do
      release = Release.latest_release

      version = if ( !params['v'].nil? && params['v'].include?('.') )
        params['v'].gsub(".", "")
      else
        params['v']
      end

      if release.nil? || release.version == version.to_i
        return [ 204, {}, "" ]
      end

      [ 200, {}, release.to_json ]
    end

    get '/updates/reload' do
      begin
        Release.unload
        Release.load(RELEASES_FILE)
      rescue Exception => e
        $logger.error e
        return 500
      end

      return [ 200, "#{Release.all_json}" ]
    end

    get '/monitor/health' do
      content_type :json
      {
        status:         "OK",
        env:            ENV['RACK_ENV'],
        releases_file:  RELEASES_FILE,
        build:          ENV['BUILD_ID'],
        commit:         ENV['BUILD_COMMIT'],
        aws_env:        ENV['AWS_ENV'],
        cluster:        ENV['CLUSTER']
      }.to_json
    end

  end
end
