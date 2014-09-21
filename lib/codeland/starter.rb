require 'codeland/starter/version'
require 'codeland/starter/configuration'
dirname = File.dirname(__FILE__)
Dir["#{dirname}/starter/integrations/*.rb"].each do |file|
  require file
end

module Codeland
  module Starter
    class << self
      attr_reader :name, :config

      def create_project(name, yaml_file)
        @name = name
        @config = Configuration.new(yaml_file)
        config.integrations.each do |integration|
          integration_class_name = integration.capitalize
          if have_integration?(integration_class_name)
            client = Integrations.const_get(integration_class_name).new
            client.create
            client.output
          end
        end
      end

      private

      def have_integration?(integration)
        const_defined?(:Integrations) && Integrations.const_defined?(integration)
      end
    end
  end
end
