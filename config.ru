#\ -s puma

$LOAD_PATH << File.dirname(__FILE__)

require 'boot'
require 'logger'
require 'net/http'
require 'app/squirrel_api'

$logger = Logger.new($stdout)
if %w(development production).include?(ENV['RACK_ENV'])
  # Use remote file for production or local file for dev.
  RELEASES_FILE = (ENV['RACK_ENV'] == "production" ) ? URI(ENV["RELEASES_FILE"]) : File.join(ENV['RACK_ROOT'], 'db', 'releases.json')
  $logger.info("Using releases_file: #{RELEASES_FILE}")

  Squirrel::Release.load(RELEASES_FILE)
  $logger.info("No releases available! Add a release to #{RELEASES_FILE}.") unless Squirrel::Release.all.size > 0
end


run Squirrel::Api
