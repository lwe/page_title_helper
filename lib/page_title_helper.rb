# frozen_string_literal: true

# PageTitleHelper provides an +ActionView+ helper method to simplify adding
# custom titles to pages.
#
# Author:: Lukas Westermann
# Copyright:: Copyright (c) 2009 Lukas Westermann (Zurich, Switzerland)
# Licence:: MIT-Licence (https://www.opensource.org/licenses/mit-license.php)
#
# See documentation for +page_title+ for usage examples and more information.
require 'active_support'

# PageTitleHelper
module PageTitleHelper
  # https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/interpolations.rb
  module Interpolations
    extend self

    def self.interpolate(pattern, *args)
      instance_methods(false).sort.reverse.inject(pattern.to_s.dup) do |result, tag|
        result.gsub(/:#{tag}/) do |_match|
          send(tag, *args)
        end
      end
    end

    def app(env)
      env[:app] || I18n.t('app.name', default: File.basename(Rails.root).humanize)
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

  def page_title(options = nil)
    return page_title!(yield) if block_given? # define title

    options = PageTitleHelper.options.merge(options || {}).symbolize_keys!
    options[:format] ||= :title # handles :format => false
    options.assert_valid_keys(:app, :default, :format)

    format, real_title = build_title_and_format(options)

    # handle format aliases
    format = PageTitleHelper.formats[format] if PageTitleHelper.formats.include?(format)

    # construct basic env to pass around
    env = { title: real_title, app: options[:app], options: options, view: self }

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

      I18n.t(keys.shift, default: keys)
    end

  private

    ##
    # Read the page title and splits it into 'real' title and the customized
    # format.
    #
    # @param {Hash} options
    #
    # @return {Array}
    #
    def build_title_and_format(options)
      raw_title = @_page_title ||= page_title_from_translation(options[:default])
      if raw_title.is_a?(Array)
        title_and_format = raw_title + [options[:format]]
        real_title, format = *title_and_format
      else
        real_title = raw_title
        format = options[:format]
      end

      [format, real_title]
    end
end

# include helper methods in ActionView
ActiveSupport.on_load(:action_view) { include PageTitleHelper }
