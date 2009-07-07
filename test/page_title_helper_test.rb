require 'test_helper'
require 'page_title_helper'

class MockRender
  def initialize(template_path = 'contacts/index.html.erb')
    @template_path = template_path
  end
  def template_path; @template_path; end
end

class MockView
  include PageTitleHelper
  
  def initialize(template_path = 'contacts/index.html.erb')
    @_first_render = MockRender.new template_path
  end
  
  def content_for(sym, &block)
    instance_variable_set('@content_for_' + sym.to_s, yield)
  end
end

I18n.backend.store_translations :en, :contacts => { :list => { :title => 'contacts.list.title' }}
I18n.backend.store_translations :en, :placeholder => 'Displaying {{name}}'


class PageTitleHelperTest < ActiveSupport::TestCase  
  test "interpolations" do    
    assert_equal 'Page title helper', PageTitleHelper::Interpolations.app('untitled', {})
    assert_equal 'Appname', PageTitleHelper::Interpolations.app('untitled', { :app => 'Appname' })
    assert_equal 'untitled', PageTitleHelper::Interpolations.title('untitled', {})
  end
  
  test "adding custom interpolation" do
    # extend Interpolations
    PageTitleHelper.interpolates :app_reverse do |title, options|
      app(title,options).reverse.downcase
    end
  
    assert_equal "anna", PageTitleHelper::Interpolations.app_reverse('untitled', { :app => 'Anna' })
    assert_equal "ppa", PageTitleHelper::Interpolations.interpolate(':app_reverse', 'foo', { :app => 'app' })
  end
  
  test "setting title to 'foo' returns 'foo'" do
    view = MockView.new
    view.page_title { "foo" }
    assert_equal 'Page title helper - foo', view.page_title
  end
  
  test "reading defaults from I18n" do
    view = MockView.new 'contacts/list.html.erb'
    assert_equal 'Page title helper - contacts.list.title', view.page_title
  end
  
  test "printing app name only if :app => true" do
    view = MockView.new
    assert_equal 'Page title helper', view.page_title(:app => true)
  end
  
  test "custom formatting options" do
    view = MockView.new
    view.page_title { "test" }
    
    assert_equal "Some app :: test", view.page_title(:app => "Some app", :format => ':app :: :title')
    assert_equal "Some app / test", view.page_title(:format => 'Some app / :title')
  end
  
  test "return value of block to be used as heading" do
    view = MockView.new
    assert_equal "untitled", view.page_title { "untitled" }
  end
  
  test "calling :format => false returns just current title, without any interpolations etc." do
    view = MockView.new
    view.page_title { "untitled" }
    assert_equal "untitled", view.page_title(:format => false)
    
    i18n_view = MockView.new 'contacts/list.html.erb'
    assert_equal "contacts.list.title", i18n_view.page_title(:format => false)
  end
  
  test "custom title using a translation with a placeholder" do
    view = MockView.new
    view.page_title { I18n.t :placeholder, :name => 'Bella' }
    assert_equal "Page title helper - Displaying Bella", view.page_title
  end
end
