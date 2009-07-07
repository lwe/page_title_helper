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
  
  # Default options, which are globally referenced and can
  # be changed globally, which might be useful in some cases.
  def self.options
    @options ||= {
      :format => ':app - :title',
      :default => :'app.tagline'
    }
  end
  
  def page_title(options = nil, &block)
    if block_given?
      content_for(:page_title) { yield }
      return read_page_title_content_block
    end
    
    options = PageTitleHelper.options.merge(options || {})
    options.assert_valid_keys(:app, :key, :default, :format)
    # just return the applications name
    return Interpolations.app('', {}) if options[:app] == true
    
    # read page title
    page_title = read_page_title_content_block
    page_title = I18n.translate(options[:key] || i18n_template_key('title'), :default => options[:default]) if page_title.blank?
    
    # return page title if format is set explicitly to false
    return page_title if options[:format] == false
    
    # else -> interpolate
    Interpolations.interpolate options[:format] || ':app - :title', page_title, options
  end
  
  protected
    
    # Access <tt>@content_for_page_title</tt> variable, though this is a tad
    # hacky, because... what if they (the rails guys) change the behaviour of
    # <tt>content_for</tt>? Well, in Rails 2.3.x it works so far.
    #
    # But to simplify compatibility with later versions, this method kinda abstracts
    # away access to the content within a <tt>content_for</tt> block.
    def read_page_title_content_block
      instance_variable_get(:'@content_for_page_title')
    end
    
    # Access +ActionView+s internal <tt>@_first_render</tt> variable, to access
    # template first rendered, this is to help create the DRY-I18n-titles magic,
    # and also kind of a hack, because this really seems to be some sort if
    # internal variable, that's why it's "abstracted" away as well.
    #
    def read_first_render_path
      @_first_render.template_path
    end
    
    def i18n_template_key(append = nil)
      ikey = read_first_render_path.gsub(/\.html\.erb$/, '').tr('/', '.')
      ikey = ikey + "." + append.to_s unless append.nil?      
      ikey
    end
end