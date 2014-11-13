require 'test_helper'
require 'page_title_helper'
require 'ostruct'

class PageTitleHelperTest < ActiveSupport::TestCase
  context 'PageTitleHelper' do
    setup do
      I18n.load_path = [File.join(File.dirname(__FILE__), 'en.yml')]
      I18n.reload!

      @view = TestView.new('contacts', 'list')
    end

    context '::Interpolations' do
      should 'interpolate :app and :title' do
        assert_equal 'Page title helper', PageTitleHelper::Interpolations.app({})
        assert_equal 'Appname', PageTitleHelper::Interpolations.app(app: 'Appname')
        assert_equal 'untitled', PageTitleHelper::Interpolations.title(title:  'untitled')
      end

      should 'allow adding custom interpolations' do
        # extend Interpolations
        PageTitleHelper.interpolates(:app_reverse) { |env| app(env).reverse.downcase }

        assert_equal 'anna', PageTitleHelper::Interpolations.app_reverse({ app: 'Anna' })
        assert_equal 'ppa', PageTitleHelper::Interpolations.interpolate(':app_reverse', app: 'app')
      end

      should 'interpolate in correct order, i.e. longest first' do
        PageTitleHelper.interpolates(:foobar) { |env| 'foobar' }
        PageTitleHelper.interpolates(:foobar_test) { |env| 'foobar_test' }
        PageTitleHelper.interpolates(:title_foobar) { |env| 'title_foobar' }

        assert_equal 'title_foobar / foobar_test / foobar / foobar_x', PageTitleHelper::Interpolations.interpolate(':title_foobar / :foobar_test / :foobar / :foobar_x', {})
      end
    end

    context '#page_title (define w/ block)' do
      should 'return title from block and render with app name' do
        assert_equal 'foo', @view.page_title { 'foo' }
        assert_equal 'foo - Page title helper', @view.page_title
      end

      should 'set custom title using a translation with a placeholder' do
        assert_equal 'Displaying Bella', @view.page_title { I18n.t(:placeholder, name: 'Bella') }
        assert_equal 'Displaying Bella - Page title helper', @view.page_title
      end
    end

    context '#page_title! (define)' do
      should 'set page title' do
        assert_equal 'test', @view.page_title!('test')
        assert_equal 'test - Page title helper', @view.page_title
      end

      should 'set page title and interpret second argument as custom format' do
        PageTitleHelper.formats[:bang] = ':title !! :app'
        assert_equal 'test', @view.page_title!('test', :bang)
        assert_equal 'test !! Page title helper', @view.page_title
      end
    end

    context '#page_title (rendering)' do
      should 'read default title from I18n, based on controller/action' do
        assert_equal 'contacts.list.title - Page title helper', @view.page_title
      end

      should 'only print app name if format: :app' do
        assert_equal 'Page title helper', @view.page_title(format: :app)
      end

      should 'print custom app name if :app defined and format: :app' do
        assert_equal 'Some app', @view.page_title(app: 'Some app', format: :app)
      end

      should 'use custom format, if :format option is defined' do
        assert_equal 'test', @view.page_title { 'test' }
        assert_equal 'Some app :: test', @view.page_title(app: 'Some app', format: ':app :: :title')
        assert_equal 'Some app / test', @view.page_title(format: 'Some app / :title')
      end

      should 'return just title if format: false is passed' do
        assert_equal 'untitled', @view.page_title { 'untitled' }
        assert_equal 'untitled', @view.page_title(format: false)
      end

      should 'return title if format: false and when using the DRY-I18n titles' do
        assert_equal 'contacts.list.title', @view.page_title(format: false)
      end

      should 'render translated :"app.tagline" if no title is available' do
        @view.controller! 'view/does', 'not_exist'
        assert_equal 'Default - Page title helper', @view.page_title
      end

      should 'render use controller.title as first fallback, if no title exists' do
        @view.controller! 'admin/account', 'index'
        assert_equal 'Account administration - Page title helper', @view.page_title(default: 'Other default')
      end

      should 'not fallback to controller.title if controller.action.title exists' do
        @view.controller! 'admin/account', 'show'
        assert_equal 'Account - Page title helper', @view.page_title(default: 'Other default')
      end

      should 'fallback to controller.new.title if create has no title' do
        @view.controller! 'admin/account', 'create'
        assert_equal 'New account - Page title helper', @view.page_title(default: 'Other default')
      end

      should 'fallback to controller.edit.title if update has no title' do
        @view.controller! 'admin/account', 'update'
        assert_equal 'Edit account - Page title helper', @view.page_title(default: 'Other default')
      end

      should 'render custom "default" string, if title is not available nor controller.title' do
        @view.controller! 'view/does', 'not_exist'
        assert_equal 'Some default - Page title helper', @view.page_title(default: 'Some default')
      end

      should 'render custom default translation, if title is not available nor controller.title' do
        @view.controller! 'view/does', 'not_exist'
        assert_equal 'Other default - Page title helper', @view.page_title(default: :'app.other_tagline')
      end
    end

    context 'README.md' do
      should 'interpolate :controller' do
        PageTitleHelper.interpolates(:controller) { |env| env[:view].controller.controller_name.humanize }
        assert_equal 'contacts.list.title - Test', @view.page_title(format: ':title - :controller')
      end
    end
  end
end
