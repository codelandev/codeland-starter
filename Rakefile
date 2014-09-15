require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -rubygems -I lib -r codeland/starter.rb'
end

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
