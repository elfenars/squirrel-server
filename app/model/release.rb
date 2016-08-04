require 'json'
require 'time'

module Squirrel
    class Release

      include Comparable

      @@releases = []

      def self.load(releases_file)
        @releases_json = []

        @@releases = JSON.parse(get_releases(releases_file)).map do |json_release|
          @releases_json.push json_release
          new(json_release)
        end

        @@releases.sort!
      end

      def self.get_releases(releases_file)
        if releases_file.is_a? URI
          Net::HTTP.get(releases_file)
        elsif releases_file.is_a? String
          File.read(releases_file)
        end
      end

      def self.unload
        @@releases.clear
      end

      def self.all
        @@releases
      end

      def self.all_json
        @releases_json.to_json
      end

      def self.latest_release
        all.last
      end

      def self.hash_reader(key, &block)
        define_method key do
          value = @attributes[key.to_s]
          value = block.call(value) if block
          value
        end
      end

      hash_reader :name
      hash_reader :version

      hash_reader :pub_date do |value|
        DateTime.iso8601(value)
      end

      hash_reader :notes

      hash_reader :url

      def initialize(attributes)
        @attributes = attributes
      end

      def to_json
        @attributes.to_json
      end

      def <=>(other)
        version <=> other.version
      end

    end
end
