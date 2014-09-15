require 'codeland/starter'
require 'thor'

module Codeland
  module Starter
    class CLI < Thor
      desc 'create NAME', 'Ask for services to create with given NAME'
      method_option :file, {
        :required => true,
        :default  => '~/.codeland-starter/config.yml',
        :aliases  => :f,
        :type     => :string
      }
      def create(name)
        Codeland::Starter.create_project(name)
      end
    end
  end
end
