require 'test_helper'
require 'page_title_helper'
require 'mocks'

class MultipleFormatsTest < ActiveSupport::TestCase  
  context "#page_title supporting multiple formats through arrays" do
    setup do
      @view = MockView.new
    end
    
    should "accept an array passed in the page_title block and use the second argument as format" do
      @view.page_title { ["Oh my...!", ":title // :app"] }
      assert_equal "Oh my...! // Page title helper", @view.page_title
    end
    
    should "still return title as string and not the array" do
      assert_equal "Oh my...!", @view.page_title { ["Oh my...!", ":title // :app"] }
    end
  end
  
  context "#page_title with format aliases" do
    setup do
      PageTitleHelper.formats[:myformat] = ":title <-> :app"      
      @view = MockView.new
    end
    
    should "have a default alias named :app" do
      assert_equal "Page title helper", @view.page_title(:format => :app)      
    end
    
    should "allow custom aliases to be defined and used" do
      @view.page_title { "Test" }
      assert_equal "Test <-> Page title helper", @view.page_title(:format => :myformat)
    end
        
    should "fallback to default format, if array is not big enough (i.e. only contains single element...)" do
      assert_equal "Test", @view.page_title { ["Test"] }
      assert_equal "Test - Page title helper", @view.page_title
    end
    
    context "used with the array block" do
      should "also allow aliases returned in that array thingy" do
        assert_equal "Test", @view.page_title { ["Test", :myformat] }
        assert_equal "Test <-> Page title helper", @view.page_title
      end 
            
      should "override locally supplied :format arguments" do
        assert_equal "Something", @view.page_title { ["Something", "* * * :title * * *"] }
        assert_equal "* * * Something * * *", @view.page_title(:format => "-= :title =-") # yeah, using x-tra ugly titles :)
      end
    end
  end
  
  context "#page_title, aliases and YAML" do
    setup do
      I18n.load_path = [File.join(File.dirname(__FILE__), "en_wohaapp.yml")]
      I18n.reload!
      PageTitleHelper.formats[:promo] = ":app > :title"
    end
    
    should "allow to overide format through YAML" do
      @view = MockView.new('pages/features.html.haml')      
      assert_equal 'Wohaapp > Feature comparison', @view.page_title
    end
    
    should "handle raw string formats from YAML as well" do
      @view = MockView.new('pages/signup.html.haml')
      assert_equal 'Sign up for Wohaapp now!', @view.page_title
    end
  end
end