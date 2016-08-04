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
        Release.load(releases_file)
      rescue Exception => e
        puts e
        [ 500, { message: e } ]
      end

      return [ 200, "#{Release.all_json}" ]
    end

  end
end
