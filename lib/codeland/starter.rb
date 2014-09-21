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
          if const_defined?("Integrations::#{integration_class_name}")
            client = class_eval("Integrations::#{integration_class_name}.new")
            client.create
            client.output
          end
        end
      end
    end
  end
end
