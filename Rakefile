require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'dotenv'
Dotenv.load

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :console do
  exec "irb -r semrush_ruby -I ./lib"
end
