# Page title helper

[![Build Status](https://travis-ci.org/lwe/page_title_helper.svg?branch=master)](https://travis-ci.org/lwe/page_title_helper)
[![Gem Version](https://badge.fury.io/rb/page_title_helper.svg)](http://badge.fury.io/rb/page_title_helper)

This project adheres to [Semantic Versioning](http://semver.org/).


## What does this gem do?

Ever wondered if there was an easier and DRY-way to set your page titles (and/or headings),
introducing _page title helper_, a small view helper for Rails 4.2 and 5
to inflect titles from controllers and actions.

In your layout, add this to your `<head>`-section:

      ...
      <title><%= page_title %></title>
      ...

That's it. Now just add translations, in e.g. `config/locales/en.yml`:

      en:
        contacts:
          index:
            title: "Contacts"

When `/contacts/` is requested, the key `:en, :contacts, :index, :title`
is looked up and printed, together with the applications basename, like: `Contacts - My cool App`.
The format etc. is of course configurable, just head down to the options.

## Installation

As gem (from rubygems.org):

    # then add the following line to Gemfile
    gem 'page_title_helper'

    # living on the bleeding edge?
    gem 'page_title_helper', git: 'git://github.com/lwe/page_title_helper.git'

## Translated titles

All translated titles are inflected from the current controller and action, so to
easily explain all lookups, here an example with the corresponding lookups:

    Admin::AccountController#index => :'admin.account.index.title'
                                      :'admin.account.title'
                                      options[:default]

For `create` and `update` a further fallback to `new.title` and `edit.title` have
been added, because they certainly are duplicates.

## Customize titles

Need a custom title, or need to fill in some placeholders? Just use the _bang_ method (`page_title!`), in e.g.
`contacts/show.html.erb` the requirement is to display the contacts name in the
`<title>-tag`as well as in the heading?

    <h1><%= page_title!(@contact.name) %></h1>

A call to `page_title` will now return the contacts name, neat :) if for example the
`<h1>` does not match the `<title>`, then well, just do something like:

    <% page_title!(@contact.name + " (" + @contact.company.name + ")") %>
    <h1><%= @contact.name %></h1>

Guess, that's it. Of course it's also possible to use `translate` within `page_title!`, to
translate custom titles, like:

    # in config/locales/en.yml:
    en:
      dashboard:
        index:
          title: "Welcome back, {{name}}"

    # in app/views/dashboard/index.html.erb:
    <h1><%= page_title!(t('.title', name: @user.first_name)) %></h1>

## More fun with <tt>:format</tt>

The `:format` option is used to specify how a title is formatted, i.e. if the app name is
prepended or appended or if it contains the account name etc. It uses a similar approach as
paperclip's path interpolations:

    page_title format: ':title / :app' # => "Contacts / My cool app"

Adding custom interpolations is as easy as defining a block, for example to access the current
controller:

    PageTitleHelper.interpolates :controller do |env|
      env[:view].controller.controller_name.humanize
    end

    page_title format: ':title / :controller / :app' # => "Welcome back / Dashboard / My cool app"

To access just the title, without any magic app stuff interpolated or appended, use:

    page_title! "untitled"
    page_title format: false # => "untitled"

Need a custom format for a single title? Just return an array:

    # in the view:
    <h1><%= page_title!(@contact.name, ":title from :company - :app") %></h1> # => <h1>Franz Meyer</h1>

    # in the <head>
    <title><%= page_title %></title> # => this time it will use custom title like "Franz Meyer from ABC Corp. - My cool app"

To streamline that feature a bit and simplify reuse of often used formats, it's possible to define format aliases like:

    # in an initializer, e.g. config/initializers/page_title_helper.rb:
    PageTitleHelper.formats[:with_company] = ":title from :company - :app"
    PageTitleHelper.formats[:promo] = ":app - :title" # show app first for promo pages :)

    # then in the view to display a contact...
    page_title! @contact.name, :with_company

    # ...or for the promo page via config/locales/en.yml (!)
    en:
      pages:
        features:
          title:
            - "Features comparison"
            - !ruby/sym promo

Pretty, cool, ain't it? The special `format: :app` works also via the `formats` hash. Then there is also a
`:default` format, which can be used to override the default format.

## All options - explained

<table>
  <tr>
    <th>Option</th><th>Description</th><th>Default</th><th>Values</th>
  </tr>
  <tr>
    <td><tt>:app</tt></td>
    <td>Specify the applications name, however it's
        recommended to define it via translation key <tt>:'app.name'</tt>.</td>
    <td>Inflected from <tt>Rails.root</tt></td>
    <td>string</td>
  </tr>
  <tr>
    <td><tt>:default</tt></td>
    <td>String which is displayed when no translation exists and no custom title
        has been specified. Can also be set to a symbol or array to take advantage of
        <tt>I18n.translate</tt>s <tt>:default</tt> option.</td>
    <td><tt>:'app.tagline'</tt></td>
    <td>string, symbol or array of those</td>
  </tr>
  <tr>
    <td><tt>:format</tt></td>
    <td>Defines the output format, accepts a string containing multiple interpolations, or
        a symbol to a format alias, see <i>More fun with <tt>:format</tt></i>. If set to
        +false+, just the current title is returned.</td>
    <td><tt>:default</tt></td>
    <td>string, symbol</td>
  </tr>
</table>
</p>

Options can be set globally via `PageTitleHelper.options`. Note, currently it only
makes sense to set `:default` globally.

To add or change formats use:

    # change the default format used (if no format is specified):
    PageTitleHelper.formats[:default] = ":title // :app"

    # add a custom format alias (which can be used with page_title(format: :promo))
    PageTitleHelper.formats[:promo] = ":app // :title"

_Note:_ it's recommended to add this kind of stuff to an initializer, like e.g.
`config/initializers/page_title_helper.rb`.

## A (maybe useful) interpolation

The internationalized controller name, with fallback to just display the humanized name:

    PageTitleHelper.interpolates :controller do |env|
      c = env[:view].controller
      I18n.t(c.controller_path.tr('/', '.') + '.controller', default: c.controller_name.humanize)
    end

_Note:_ Put this kind of stuff into an initializer, like `config/initializers/page_title_helper.rb` or something like that.

## Licence and copyright
Copyright (c) 2009 Lukas Westermann (Zurich, Switzerland), released under the MIT license
