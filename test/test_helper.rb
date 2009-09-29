require 'rubygems'
require 'active_support'
require 'action_view'

unless Object.const_defined?('IRB')
  require 'active_support/test_case'
  require 'shoulda'
  require 'rr'
  # enable RR to use all the mocking magic, uweee!
  Test::Unit::TestCase.send(:include, RR::Adapters::TestUnit)
end

ROOT = File.expand_path File.dirname(File.dirname(__FILE__))
RAILS_ROOT = '/this/is/just/for/testing/page_title_helper'
RAILS_ENV = 'test'