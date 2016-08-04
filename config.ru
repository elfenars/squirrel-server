#\ -s puma

$LOAD_PATH << File.dirname(__FILE__)

require 'net/http'
require 'config/boot'
require 'logger'
require 'model/release'

if %w(development production).include?(ENV['RACK_ENV'])
  $logger = Logger.new($stdout)

  releases_file = if ( ENV['RACK_ENV'] == "production" )
    $logger.info("Using remote file")
    URI(ENV["RELEASES_FILE"])
  else
    $logger.info("Using local file")
    File.join(ENV['RACK_ROOT'], 'db', 'releases.json')
  end

  Squirrel::Release.load(releases_file)
  $logger.info("No releases available! Add a release to #{releases_file}.") unless Squirrel::Release.all.size > 0
end

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
        Release.load(releases_file)
      rescue Exception => e
        puts e
        [ 500, { message: e } ]
      end

      return [ 200, "#{Release.all_json}" ]
    end

  end
end

run Squirrel::Api
