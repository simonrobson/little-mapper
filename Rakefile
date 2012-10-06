require "bundler/gem_tasks"
require "minitest/unit"

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'lib/little_helper'
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb', 'test/integration/*_test.rb']
  t.verbose = true
end

task :default => :test
