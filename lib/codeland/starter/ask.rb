module Codeland
  module Starter
    module Ask
      class << self
        def question?(question)
          print "#{question} (Y/N): "
          !!(STDIN.gets.chomp =~ /\Ay(es)?/i)
        end

        def heroku?
          question?('Wants heroku?')
        end
      end
    end
  end
end
