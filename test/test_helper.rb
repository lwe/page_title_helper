require 'rubygems'
require 'active_support'
require 'action_view'
require File.join(File.dirname(__FILE__), '..', 'init')

unless defined?(IRB)
  require 'active_support/test_case'
  require 'shoulda'
end

# fake global rails object
Rails = Object.new
Rails.class_eval do
  def root; @pathname ||= Pathname.new('/this/is/just/for/testing/page_title_helper') end
  def env; "test" end
end

# Mock ActionView a bit to allow easy (fake) template assignment
class TestView < ActionView::Base
  def initialize(controller_path = nil, action = nil)
    @controller = ActionView::TestCase::TestController.new
    @controller.controller_path = controller_path
    self.params[:action] = action if action
  end
  
  def controller!(controller_path, action)
    @controller.controller_path = controller_path
    self.params[:action] = action
  end
  
  def controller
    @controller
  end
end