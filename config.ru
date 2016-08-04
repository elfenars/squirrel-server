#\ -s puma

$LOAD_PATH << File.dirname(__FILE__)

require 'boot'
require 'logger'
require 'net/http'
require 'app/squirrel_api'

if %w(development production).include?(ENV['RACK_ENV'])
  $logger = Logger.new($stdout)

  # Use remote file for production or local file for dev.
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


run Squirrel::Api
