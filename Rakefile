require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "page_title_helper"
    gemspec.summary = "Simple, internationalized and DRY page titles and headings for rails."
    gemspec.email = "lukas.westermann@gmail.com"
    gemspec.homepage = "http://github.com/lwe/page_title_helper"
    gemspec.authors = ["Lukas Westermann"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc 'Test the page_title_helper plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the page_title_helper plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'PageTitleHelper'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :metrics do
  desc 'Report all metrics, i.e. stats and code coverage.'
  task :all => [:stats, :coverage]
  
  desc 'Report code statistics for library and tests to shell.'
  task :stats do |t|
    require 'code_statistics'
    dirs = {
      'Libraries' => 'lib',
      'Unit tests' => 'test'
    }.map { |name,dir| [name, File.join(File.dirname(__FILE__), dir)] }
    CodeStatistics.new(*dirs).to_s
  end
  
  desc 'Report code coverage to HTML (doc/coverage) and shell (requires rcov).'
  task :coverage do |t|
    rm_f "doc/coverage"
    mkdir_p "doc/coverage"
    rcov = %(rcov -Ilib:test --exclude '\/gems\/' -o doc/coverage -T test/*_test.rb )
    system rcov
  end
end

desc 'Start IRB console with loaded test/test_helper.rb and PageTitleHelper.'
task :console do |t|
  chdir File.dirname(__FILE__)
  exec 'irb -Ilib -r test/test_helper.rb -r page_title_helper'
end

desc 'Clean up generated files.'
task :clean do |t|
  FileUtils.rm_rf "doc"
  FileUtils.rm_rf "pkg"
end
