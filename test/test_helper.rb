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

# fake global rails object
Rails = Object.new
Rails.class_eval do
  def root; @pathname ||= Pathname.new('/this/is/just/for/testing/page_title_helper') end
  def env; "test" end
end

# kinda hack ActionView a bit to allow easy (fake) template assignment
class ActionView::Base
  def template=(template)
    @_first_render = template.respond_to?(:template_path) ? template : ActionView::Template.new(template)
  end
  alias_method :template_path=, :template=
end