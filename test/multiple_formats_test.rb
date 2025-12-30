# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

class MultipleFormatsTest < ActiveSupport::TestCase
  context '#page_title supporting multiple formats through arrays' do
    setup do
      @view = TestView.new('contacts', 'list')
    end

    should 'accept an array passed in the page_title block and use the second argument as format' do
      @view.page_title { ['Oh my...!', ':title // :app'] }
      assert_equal 'Oh my...! // Page title helper', @view.page_title
    end

    should 'still return title as string and not the array' do
      assert_equal('Oh my...!', @view.page_title { ['Oh my...!', ':title // :app'] })
    end
  end

  context '#page_title with format aliases' do
    setup do
      PageTitleHelper.formats[:myformat] = ':title <-> :app'
      @view = TestView.new('contacts', 'list')
    end

    should 'have a default alias named :app' do
      assert_equal 'Page title helper', @view.page_title(format: :app)
    end

    should 'allow custom aliases to be defined and used' do
      @view.page_title { 'Test' }
      assert_equal 'Test <-> Page title helper', @view.page_title(format: :myformat)
    end

    should 'fallback to default format, if array is not big enough (i.e. only contains single element...)' do
      assert_equal('Test', @view.page_title { ['Test'] })
      assert_equal 'Test - Page title helper', @view.page_title
    end

    context 'used with the array block' do
      should 'also allow aliases returned in that array thingy' do
        assert_equal('Test', @view.page_title { ['Test', :myformat] })
        assert_equal 'Test <-> Page title helper', @view.page_title
      end

      should 'override locally supplied :format arguments' do
        assert_equal('Something', @view.page_title { ['Something', '* * * :title * * *'] })
        # yeah, using x-tra ugly titles :)
        assert_equal '* * * Something * * *', @view.page_title(format: '-= :title =-')
      end
    end
  end

  context '#page_title, aliases and YAML' do
    setup do
      PageTitleHelper.formats[:promo] = ':app > :title'
      @view = TestView.new
    end

    should 'allow to override format through YAML' do
      with_i18n_backend_from_file File.expand_path('en_wohaapp.yml', __dir__) do
        @view.controller! 'pages', 'features'
        assert_equal 'Wohaapp > Feature comparison', @view.page_title
      end
    end

    should 'handle raw string formats from YAML as well' do
      with_i18n_backend_from_file File.expand_path('en_wohaapp.yml', __dir__) do
        @view.controller! 'pages', 'signup'
        assert_equal 'Sign up for Wohaapp now!', @view.page_title
      end
    end
  end

  private

    def with_i18n_backend_from_file(file)
      original_backend = I18n.backend

      backend = I18n::Backend::Simple.new
      backend.load_translations(file)

      I18n.backend = backend

      yield
    ensure
      I18n.backend = original_backend
    end
end
