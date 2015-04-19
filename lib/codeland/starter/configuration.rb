require 'yaml'
require 'codeland/starter'

module Codeland
  module Starter
    class Configuration
      attr_reader :yaml

      DEFAULT_FILENAME = 'codeland-starter.yml'

      def initialize(yaml_file = nil)
        @yaml = if yaml_file && File.exists?(yaml_file)
                  YAML.load_file(File.open(yaml_file))
                elsif File.exists?(default_yaml_file)
                  YAML.load_file(File.open(default_yaml_file))
                else
                  message = 'Please install with `codeland-starter install`'
                  raise MissingYAML, message
                end
      end

      def default_yaml_file
        File.join(Dir.home, DEFAULT_FILENAME)
      end

      def integrations
        yaml['integrations']
      end

      def self.[](key)
        Starter.config.yaml[key] if Starter.config
      end
    end

    class MissingYAML < StandardError; end
  end
end
