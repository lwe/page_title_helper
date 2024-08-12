$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'page_title_helper/version'

Gem::Specification.new do |s|
  s.name        = 'page_title_helper'
  s.version     = PageTitleHelper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Simple, internationalized and DRY page titles and headings for Rails.'
  s.description = 'Simple, internationalized and DRY page titles and headings for Rails.'

  s.required_ruby_version = '>= 3.1.0'

  s.authors  = ['Lukas Westermann']
  s.email    = ['lukas.westermann@gmail.com']
  s.homepage = 'https://github.com/lwe/page_title_helper'

  s.files            = %w[Gemfile LICENSE README.md CODE_OF_CONDUCT.md CHANGELOG.md Rakefile
                          page_title_helper.gemspec] + Dir['**/*.{rb,yml}']
  s.test_files       = s.files.grep(%r{^(test|spec)/})
  s.require_path     = 'lib'

  s.license          = 'MIT'

  s.add_dependency 'rails', '>= 6.1.0', '< 7.3'

  s.add_development_dependency 'rake', '~> 13.2.1'
  s.add_development_dependency 'rubocop', '~> 1.65.1'
  s.add_development_dependency 'rubocop-rails', '~> 2.25.1'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'shoulda', '~> 4.0.0'
end
