# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'page_title_helper'
  spec.summary = 'Simple, internationalized and DRY page titles and headings for Railspec.'
  spec.version = '11.0.0'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.3.0'

  spec.homepage = 'https://github.com/lwe/page_title_helper'
  spec.authors = ['Lukas Westermann']
  spec.email = ['lukaspec.westermann@gmail.com']

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/lwe/page_title_helper/issues',
    'changelog_uri' => 'https://github.com/lwe/page_title_helper/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/page_title_helper',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/lwe/page_title_helper'
  }

  spec.files = %w[
    CHANGELOG.md
    Gemfile
    LICENSE
    README.md
    Rakefile
    lib/page_title_helper.rb
    page_title_helper.gemspec
  ]
  spec.extra_rdoc_files = %w[CHANGELOG.md LICENSE README.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 8.0.0', '< 8.2'

  spec.add_development_dependency 'rake', '~> 13.4.2'
  spec.add_development_dependency 'rubocop', '~> 1.90.0'
  spec.add_development_dependency 'rubocop-rails', '~> 2.37.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.7.1'
  spec.add_development_dependency 'shoulda', '~> 4.0.0'
end
