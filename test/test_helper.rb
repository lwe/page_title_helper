# frozen_string_literal: true

# This line can be dropped once we no longer support Rails 7.0.
require 'logger'
# This line can be dropped once we no longer support Rails 7.1 and 7.2.
require 'uri'
require 'active_support'
require 'action_view'
require 'page_title_helper'

unless defined?(IRB)
  require 'active_support/test_case'
  require 'shoulda'
end

# Use sorted tests. We need to change that after the tests have been converted
# to RSpec.
ActiveSupport.test_order = :sorted

# fake global Rails module
module Rails
  class << self
    def root
      @root ||= Pathname.new('/this/is/just/for/testing/page_title_helper')
    end

    def env
      'test'
    end
  end
end

# Mock ActionView a bit to allow easy (fake) template assignment
class TestView < ActionView::Base
  attr_reader :controller

  def initialize(controller_path = nil, action = nil)
    @controller = ActionView::TestCase::TestController.new
    @controller.controller_path = controller_path
    params[:action] = action if action
  end

  def controller!(controller_path, action)
    @controller.controller_path = controller_path
    params[:action] = action
  end
end
