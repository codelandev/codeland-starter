require 'codeland/starter'
require 'platform-api'

module Codeland
  module Starter
    module Integrations
      class Heroku
        attr_reader :app

        def initialize
          token = if Configuration['heroku']
                    Configuration['heroku']['oauth_token']
                  else
                    yaml = Starter.config.yaml
                    message = "Missing heroku key in #{yaml}"
                    missing_config(message)
                  end
          @app = {}
          @success = false
          @api = PlatformAPI.connect_oauth(token)
        end

        def perform
          create
          output
        end

        def create
          begin
            @app = create_app(Starter.name)
            @success = true
          rescue Excon::Errors::Unauthorized
            yaml = Starter.config.yaml
            missing_config("Please verify the Heroku oauth key in #{yaml}")
          rescue Excon::Errors::UnprocessableEntity
            @app = create_random_app
            @success = true
          end
        end

        def output
          if success?
            puts <<-MESSAGE
            Heroku created with
            URL: #{app['web_url']}
            Git remote: #{app['git_url']}
            MESSAGE
          end
        end

        private

        attr_reader :api

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

        def success?
          @success
        end

        def missing_config(message)
          raise MissingYAML, message
        end
      end
    end
  end
end
