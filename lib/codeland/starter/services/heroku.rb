require 'codeland/starter/env'
require 'platform-api'

module Codeland
  module Starter
    module Services
      class Heroku
        def initialize(name)
          @name = name
          @api  = PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN'])
        end

        def create
          begin
            create_app(name)
          rescue Excon::Errors::Unauthorized
            raise Env::EnvNotSet, 'Please verify the Heroku key.'
          rescue Excon::Errors::UnprocessableEntity
            create_random_app
          end
        end

        private

        attr_reader :api, :name

        def create_random_app
          puts 'Heroku app already in use. Using a random name'
          create_app
        end

        def create_app(app_name = nil)
          api.app.create({
            :name   => app_name,
            :region => 'us',
            :stack  => 'cedar'
          })
        end
      end
    end
  end
end
