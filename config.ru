#\ -s puma

$LOAD_PATH << File.dirname(__FILE__)

require 'boot'
require 'logger'
require 'net/http'
require 'app/squirrel_api'

$logger = Logger.new(STDOUT)

if (ENV['RACK_ENV'] == "production" )
  $logger.level = Logger::INFO
  RELEASES_FILE = URI(ENV["RELEASES_FILE"])
else
  RELEASES_FILE = File.join(ENV['RACK_ROOT'], 'db', 'releases.json')
  $logger.level = Logger::DEBUG
end

Squirrel::Release.load(RELEASES_FILE)
$logger.info("Using releases_file: #{RELEASES_FILE}")
$logger.info("No releases available! Add a release to #{RELEASES_FILE}.") unless Squirrel::Release.all.size > 0

run Squirrel::Api
