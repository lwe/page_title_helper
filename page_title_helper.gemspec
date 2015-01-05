# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "page_title_helper/version"

Gem::Specification.new do |s|
  s.name        = "page_title_helper"
  s.version     = PageTitleHelper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Simple, internationalized and DRY page titles and headings for Rails."
  s.description = "Simple, internationalized and DRY page titles and headings for rails."

  s.required_ruby_version     = ">= 1.9.3"
  s.required_rubygems_version = ">= 1.3.6"

  s.authors  = ["Lukas Westermann"]
  s.email    = ["lukas.westermann@gmail.com"]
  s.homepage = "http://github.com/lwe/page_title_helper"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path     = 'lib'

  s.license          = 'MIT'

  s.add_dependency 'rails', '>= 3.2.0'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rake', '>= 10.3.2'
  s.add_development_dependency 'shoulda'
end
