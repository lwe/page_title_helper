# PageTitleHelper
module PageTitleHelper
  module Interpolations
    extend self
    
    # Returns a sorted list of all interpolations.
    def self.all
      self.instance_methods(false).sort
    end
        
    def self.interpolate(pattern, *args)
      all.reverse.inject(pattern.dup) do |result, tag|
        result.gsub(/:#{tag}/) do |match|
          send(tag, *args)
        end
      end
    end
    
    def app(title, options)
      options[:app] || I18n.translate(:'app.name', :default => File.basename(RAILS_ROOT).humanize)
    end
    
    def title(title, options)
      title
    end
  end
  
  # Add new, custom, interpolation.
  def self.interpolates(key, &block)
    Interpolations.send(:define_method, key, &block)
  end
  
  def page_title(options = nil, &block)
    if block_given?
      page_title = yield
      content_for(:page_title) { page_title }
      return page_title
    end
    
    options = options || {}
    
    return Interpolations.app('', {}) if options[:app] == true
    
    page_title = instance_variable_get(:'@content_for_page_title') # NOTE: what happens if this changes...
    page_title = I18n.translate(options[:key] || i18n_template_key('title'), :default => (options[:default] || :'app.tagline')) if page_title.blank?      
    return page_title if options[:heading]
    
    Interpolations.interpolate options[:format] || ':app - :title', page_title, options
  end
  
  protected
    def i18n_template_key(append = nil)
      ikey = @_first_render.template_path.gsub(/\.html\.erb$/, '').tr('/', '.')
      ikey = ikey + "." + append.to_s unless append.nil?      
      ikey
    end
end