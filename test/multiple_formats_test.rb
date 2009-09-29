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
    
    should "also allows aliases returned in that array thingy within page_title-blocks" do
      assert_equal "Test", @view.page_title { ["Test", :myformat] }
      assert_equal "Test <-> Page title helper", @view.page_title
    end
  end
end