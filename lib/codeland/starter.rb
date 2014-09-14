require 'codeland/starter/version'
require 'codeland/starter/ask'
require 'codeland/starter/services/heroku'
require 'codeland/starter/env'

module Codeland
  module Starter
    class << self
      attr_reader :name

      def create_project(name)
        @name = name
        create_heroku if Ask.heroku?
      end

      def create_heroku
        begin
          Env.service_ready?('Heroku')
          heroku = Services::Heroku.new(name)
          heroku.create
        rescue Env::EnvNotSet => e
          puts e
          exit
        end
      end
    end
  end
end
