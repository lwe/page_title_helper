require 'rubygems'
require 'bundler/setup'
require 'rake/testtask'

include Rake::DSL

Bundler::GemHelper.install_tasks

desc 'Default: run unit tests.'
task default: :test

desc 'Test the page_title_helper plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
