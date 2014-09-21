require 'codeland/starter'
require 'thor'

module Codeland
  module Starter
    class CLI < Thor
      include Thor::Actions

      desc 'create NAME', 'Ask for services to create with given NAME'
      method_option :file, {
        :required => true,
        :default  => "~/#{Configuration::DEFAULT_FILENAME}",
        :aliases  => :f,
        :type     => :string
      }
      def create(name)
        Codeland::Starter.create_project(name, options[:file])
      end

      desc 'install', "Setup configuration yml to ~/#{Configuration::DEFAULT_FILENAME}"
      def install
        destination = File.join(Dir.home, Configuration::DEFAULT_FILENAME)
        copy_file('codeland-starter.yml', destination)
      end

      private

      def self.source_root
        File.dirname(__FILE__)
      end
    end
  end
end
