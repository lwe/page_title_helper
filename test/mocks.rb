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
  
  def controller; nil; end
end
