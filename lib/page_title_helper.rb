# PageTitleHelper provides an +ActionView+ helper method to simplify adding
# custom titles to pages.
#
# Author:: Lukas Westermann
# Copyright:: Copyright (c) 2009 Lukas Westermann (Zurich, Switzerland)
# Licence:: MIT-Licence (http://www.opensource.org/licenses/mit-license.php)
#
# See documentation for +page_title+ for usage examples and more informations.
require 'active_support'

# PageTitleHelper
module PageTitleHelper

  # http://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/interpolations.rb
  module Interpolations
    extend self

    def self.interpolate(pattern, *args)
      instance_methods(false).sort.reverse.inject(pattern.to_s.dup) do |result, tag|
        result.gsub(/:#{tag}/) do |match|
          send(tag, *args)
        end
      end
    end

    def app(env)
      env[:app] || I18n.translate('app.name', default: File.basename(Rails.root).humanize)
    end

    def title(env)
      env[:title]
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
      format: :default,
      default: :'app.tagline'
    }
  end

  # Defined alias formats, pretty useful.
  def self.formats
    @formats ||= {
      app: ':app',
      default: ':title - :app',
      title: ':title'
    }
  end

  # Specify page title
  def page_title!(*args)
    @_page_title = args.size > 1 ? args : args.first
    @_page_title.is_a?(Array) ? @_page_title.first : @_page_title
  end

  def page_title(options = nil, &block)
    return page_title!(yield) if block_given? # define title

    options = PageTitleHelper.options.merge(options || {}).symbolize_keys!
    options[:format] ||= :title # handles :format => false
    options.assert_valid_keys(:app, :default, :format)

    # read page title and split into 'real' title and customized format
    title = @_page_title || page_title_from_translation(options[:default])
    title, options[:format] = *(title << options[:format]) if title.is_a?(Array)

    # handle format aliases
    format = options.delete(:format)
    format = PageTitleHelper.formats[format] if PageTitleHelper.formats.include?(format)

    # construct basic env to pass around
    env = { title: title, app: options.delete(:app), options: options, view: self }

    # interpolate format
    Interpolations.interpolate(format, env)
  end

  protected

    # Find translation for `controller.action.title` combination, falls back to
    # `controller.title` or supplied default if no title was found.
    def page_title_from_translation(default)
      base = controller.controller_path.tr('/', '.')
      action = params[:action].to_s

      keys = [:"#{base}.#{action}.title"]
      keys << :"#{base}.new.title" if action == 'create'
      keys << :"#{base}.edit.title" if action == 'update'
      keys << :"#{base}.title"
      keys << default

      I18n.translate(keys.shift, default: keys)
    end
end

# include helper methods in ActionView
ActiveSupport.on_load(:action_view) { include PageTitleHelper }
