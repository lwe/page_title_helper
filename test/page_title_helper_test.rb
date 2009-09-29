require 'test_helper'
require 'page_title_helper'
require 'ostruct'
require 'mocks'


class PageTitleHelperTest < ActiveSupport::TestCase  
  def setup
    I18n.load_path = [File.join(File.dirname(__FILE__), 'en.yml')]
    I18n.reload!
  end
  
  test "interpolations" do    
    assert_equal 'Page title helper', PageTitleHelper::Interpolations.app(OpenStruct.new(:options => {}))
    assert_equal 'Appname', PageTitleHelper::Interpolations.app(OpenStruct.new(:options => { :app => 'Appname' }))
    assert_equal 'untitled', PageTitleHelper::Interpolations.title(OpenStruct.new({:title => 'untitled'}))
  end
  
  test "adding custom interpolation" do
    # extend Interpolations
    PageTitleHelper.interpolates(:app_reverse) { |env| app(env).reverse.downcase }
  
    assert_equal "anna", PageTitleHelper::Interpolations.app_reverse(OpenStruct.new(:options => { :app => 'Anna' }))
    assert_equal "ppa", PageTitleHelper::Interpolations.interpolate(':app_reverse', OpenStruct.new(:options => { :app => 'app' }))
  end
  
  test "that interpolations which are equaly named do match in correct order (longest first)" do
    PageTitleHelper.interpolates(:foobar) { "foobar" }
    PageTitleHelper.interpolates(:foobar_test) { "foobar_test" }
    PageTitleHelper.interpolates(:title_foobar) { "title_foobar" }
    
    assert_equal "title_foobar / foobar_test / foobar / foobar_x", PageTitleHelper::Interpolations.interpolate(":title_foobar / :foobar_test / :foobar / :foobar_x", nil)
  end
  
  
  test "setting title to 'foo' returns 'foo'" do
    view = MockView.new
    view.page_title { "foo" }
    assert_equal 'foo - Page title helper', view.page_title
  end
  
  test "reading defaults from I18n" do
    view = MockView.new 'contacts/list.html.erb'
    assert_equal 'contacts.list.title - Page title helper', view.page_title
  end
  
  test "printing app name only if :format => :app" do
    view = MockView.new
    assert_equal 'Page title helper', view.page_title(:format => :app)
  end
  
  test "printing custom app name if :app defined and :format => :app" do
    view = MockView.new
    assert_equal "Some app", view.page_title(:app => 'Some app', :format => :app)
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
    assert_equal "Displaying Bella - Page title helper", view.page_title
  end
  
  test "render translated :'app.tagline' if no title is available" do
    view = MockView.new 'view/does/not_exist.html.erb'
    assert_equal "Default - Page title helper", view.page_title
  end
  
  test "render custom 'default' string, if title is not available" do
    view = MockView.new 'view/does/not_exist.html.erb'
    assert_equal 'Some default - Page title helper', view.page_title(:default => 'Some default')
  end
  
  test "render custom default translation, if title is not available" do
    view = MockView.new 'view/does/not_exist.html.erb'
    assert_equal 'Other default - Page title helper', view.page_title(:default => :'app.other_tagline')
  end
  
  test "render auto-title using custom suffix 'page_title'" do
    view = MockView.new 'contacts/list.html.erb'
    assert_equal 'custom contacts title - Page title helper', view.page_title(:suffix => :page_title)
  end
  
  test "ensure that it works with other template engines, like .html.haml" do
    view = MockView.new('contacts/myhaml.html.haml')
    assert_equal 'this is haml! - Page title helper', view.page_title
  end  
end
