# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{page_title_helper}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lukas Westermann"]
  s.date = %q{2009-07-07}
  s.description = %q{Ever wondered if there was an easier and DRY-way to set your page titles (and/or headings)? Now there is.}
  s.email = %q{lukas.westermann@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "init.rb",
     "lib/page_title_helper.rb",
     "test/page_title_helper_test.rb",
     "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/lwe/page_title_helper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Simple, internationalized and DRY page titles and headings for rails.}
  s.test_files = [
    "test/page_title_helper_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 2.3.0"])
    else
      s.add_dependency(%q<rails>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 2.3.0"])
  end
end
