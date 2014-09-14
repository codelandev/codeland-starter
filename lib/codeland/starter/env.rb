module Codeland
  module Starter
    module Env
      class << self
        KEYS = {
          'Heroku' => %w(HEROKU_OAUTH_TOKEN)
        }

        def service_ready?(service)
          missing_keys = KEYS[service].reject{|key| ENV.has_key?(key) }
          raise EnvNotSet, missing_keys.join(', ') if missing_keys.any?
        end
      end

      class EnvNotSet < StandardError; end
    end
  end
end
