# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'page_title_helper'
  s.summary = 'Simple, internationalized and DRY page titles and headings for Rails.'
  s.version = '11.0.0'
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.3.0'

  s.homepage = 'https://github.com/lwe/page_title_helper'
  s.authors = ['Lukas Westermann']
  s.email = ['lukas.westermann@gmail.com']

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/lwe/page_title_helper/issues',
    'changelog_uri' => 'https://github.com/lwe/page_title_helper/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/page_title_helper',
    'homepage_uri' => s.homepage,
    'source_code_uri' => 'https://github.com/lwe/page_title_helper'
  }

  s.files = %w[
    CHANGELOG.md
    Gemfile
    LICENSE
    README.md
    Rakefile
    lib/page_title_helper.rb
    page_title_helper.gemspec
  ]
  s.extra_rdoc_files = %w[CHANGELOG.md LICENSE README.md]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 8.0.0', '< 8.2'

  s.add_development_dependency 'rake', '~> 13.4.2'
  s.add_development_dependency 'rubocop', '~> 1.90.0'
  s.add_development_dependency 'rubocop-rails', '~> 2.37.0'
  s.add_development_dependency 'rubocop-rake', '~> 0.7.1'
  s.add_development_dependency 'shoulda', '~> 4.0.0'
end
