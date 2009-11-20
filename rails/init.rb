require 'page_title_helper'

# include helper methods in ActionView
ActionView::Base.send(:include, PageTitleHelper) if defined?(ActionView)
