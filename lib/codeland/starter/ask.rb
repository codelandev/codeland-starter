module Codeland
  module Starter
    module Ask
      class << self
        def question?(question)
          print "#{question} (Y/N): "
          !!(gets.chomp =~ /\Ay(es)?/i)
        end
      end
    end
  end
end
