require 'rubygems'
require 'active_support'
require 'action_view'
require File.join(File.dirname(__FILE__), '..', 'rails', 'init')

unless defined?(IRB)
  require 'active_support/test_case'
  require 'shoulda'
  require 'rr'
  # enable RR to use all the mocking magic, uweee!
  Test::Unit::TestCase.send(:include, RR::Adapters::TestUnit)
end

ROOT = File.expand_path File.dirname(File.dirname(__FILE__))
RAILS_ROOT = '/this/is/just/for/testing/page_title_helper'
RAILS_ENV = 'test'

class ActionView::Base
  def template=(template)
    @_first_render = template.respond_to?(:template_path) ? template : ActionView::Template.new(template)
  end
  alias_method :template_path=, :template=
end