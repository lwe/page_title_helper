# Page title helper

Ever wondered if there was an easier and DRY-way to set your page titles (and/or headings). Backed
by Rails (only tested on 2.3.x) and it's new `I18n`-class the solution is a simple helper method.

In your layout add this to your `<head>-section`:

      ...
      <title><%=h page_title %></title>
      ...
      
That's it. Now just add your translations, to the locales, in e.g. `config/locales/en.yml`:

      en:
        contacts:
          index:
            title: "Contacts"
            
When `contacs/index.html.erb` is rendered, the key `:en, :contacts, :index, :title`
is looked up and printed, together with the applications basename, like: `My cool app - Contacts`.
The format etc. is of course configurable, just head down to the options.

## Installation

As gem (from gemcutter.org, as of version 0.7.0):

    sudo gem install page_title_helper [-s http://gemcutter.org]
    
    # then add the following line to config/environment.rb
    config.gem 'page_title_helper', :source => 'http://gemcutter.org'
    
or as plain old Rails plugin:

    ./script/plugin install git://github.com/lwe/page_title_helper.git

## Customize titles

Need a custom title, or need to fill in some placeholders? Just use the _bang_ method (`page_title!`), in e.g.
`contacts/show.html.erb` the requirement is to display the contacts name in the
`<title>-tag`as well as in the heading?

    <h1><%=h page_title!(@contact.name) %></h1>
    
A call to `page_title` will now return the contacts name, neat :) if for example the
`<h1>` does not match the `<title>`, then well, just do something like:

    <% page_title!(@contact.name + " (" + @contact.company.name + ")") %>
    <h1><%=h @contact.name %></h1>
    
Guess, that's it. Of course it's also possible to use `translate` with `page_title!`, to
translate customzied titles, like:

    # in config/locales/en.yml:
    en:
      dashboard:
        index:
          title: "Welcome back, {{name}}"

    # in app/views/dashboard/index.html.erb:
    <h1><%=h page_title!(t('.title', :name => @user.first_name)) %></h1>

## More fun with <tt>:format</tt>

The `:format` option is used to specify how a title is formatted, i.e. if the app name is
prependor appended, or if it contains the account name etc. It uses a similar approach as
paperclip's path interpolations:

    page_title :format => ':title / :app' # => "Contacts / My cool app"
    
Adding custom interpolations is as easy as defining a block, for example to access the current
controller:

    PageTitleHelper.interpolates :controller do |env|
      env.controller.controller_name.humanize
    end
    
    page_title :format => ':title / :controller / :app' # => "Welcome back / Dashboard / My cool app"
    
To access just the title, without any magic app stuff interpolated or appended, use:

    page_title! "untitled"
    page_title :format => false # => "untitled"
    
Need a custom format for a single title? Just return an array:

    # in the view:
    <h1><%=h page_title!(@contact.name, ":title from :company - :app") %></h1> # => <h1>Franz Meyer</h1>
    
    # in the <head>
    <title><%=h(page_title) %></title> # => this time it will use custom title like "Franz Meyer from ABC Corp. - MyCoolApp"
    
To streamline that feature a bit and simplify reuse of often used formats, it's now possible to define format aliases like:

    # in an initializer:
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

Pretty, cool, aint it? The special `:format => :app` works also with the `formats` hash. Then there is also a
`:default` format, which should be used to override the default format.

## All options - explained

<table>
  <tr>
    <th>Option</th><th>Description</th><th>Default</th><th>Values</th>
  </tr>
  <tr>
    <td><tt>:app</tt></td>
    <td>Specify the applications name, however it's
        recommended to define the translation key <tt>:'app.name'</tt>.</td>
    <td>Inflected from <tt>RAILS_ROOT</tt></td>
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
  <tr>
    <td><tt>:suffix</tt></td>
    <td>Not happy with the fact that the translations must be named like
        <tt>en -> contacts -> index -> title</tt>, but prefer e.g. them to be suffixed with
        <tt>page_title</tt>? Then just set <tt>:suffix => :page_title</tt>.</td>
    <td><tt>:title</tt></td>
    <td>symbol or string</td>
  </tr>
</table>
</p>

If an option should be set globally it's possible to change the default options hash as follows:

    PageTitleHelper.options[:suffix] = :page_title
    
Note, currently it only makes sense to set `:default` and/or `:page_title` globally.
To add or change formats use:

    # change the default format used (if no format is specified):
    PageTitleHelper.formats[:default] = ":title // :app"
    
    # add a custom format alias (which can be used with page_title(:format => :promo))
    PageTitleHelper.formats[:promo] = ":app // :title"
    
_Note:_ it's recommended to add this kind of stuff to an initializer.

## A (maybe useful) interpolation

The internationalized controller name, with fallback to just display the humanized name:

    PageTitleHelper.interpolates :controller do |env|
      I18n.t env.controller.controller_path.tr('/','.') + '.controller', :default => env.controller.controller_name.humanize
    end
    
_Note:_ Put this kind of stuff into an initilizer, like `config/initializers/page_title.rb` or someting like that.
    
## Licence and copyright
Copyright (c) 2009 Lukas Westermann (Zurich, Switzerland), released under the MIT license
