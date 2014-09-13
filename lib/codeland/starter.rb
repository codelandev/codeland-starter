require 'codeland/starter/version'
require 'codeland/starter/ask'

module Codeland
  module Starter
    class << self
      attr_reader :name

      def create_project(name)
        @name = name
      end
    end
  end
end
