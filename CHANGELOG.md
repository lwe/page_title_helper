# Page title helper change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/).

Read more at [Keep a CHANGELOG](https://keepachangelog.com/en/0.3.0/)
about why a change log is important.

## x.y.z

### Added
- Add support for Rails 7.0 (#131)
- Add support for Ruby 3.1 (#143)

### Changed

### Deprecated

### Removed
- Drop support for Ruby 2.5 and 2.6 (#127, #145)

### Fixed
- Avoid modifying a frozen array in Ruby 3 (#135)

### Security

## 5.0.0

### Added
- Add support for Ruby 3 (#120)
- Add automatic gem release (#122)
- Add support for Rails 6.1 (#113, #114)
- Officially support Ruby 2.7 (#103)

### Removed
- Drop support for Ruby 2.4 (#109)
- Drop support for Rails < 5.2 (#104)

### Fixed
- Use a better-maintained Ruby setup for the CI (#121)
- Fix warnings in the `.travis.yml` (#106)

## 4.0.0

### Added
- Add support for Rails 6.0 (#94)

### Removed
- Drop support for Ruby < 2.4 (#93)

## 3.0.0

### Added
- Add Ruby 2.4.0 to the build matrix (#68)
- Add a CHANGELOG.md (#59)
- Add RuboCop checking to the CI (#52)
- Add a CODE_OF_CONDUCT.md (#51)
- Update Ruby to 2.3.3 and 2.2.6 on Travis (#38)
- Add Ruby 2.3.0 to the build matrix
- Re-add Ruby 2.0.0 to the build matrix (#29)
- Test against Ruby 2.2
- Use Appraisal for building with different Rails versions (#19)

### Changed
- Replaced Appraisals with specific Gemfiles (#41)
- Delete obsolete init.rb file (#61)
- Add Rails 5.0 to the build matrix (#42)
- Raise RVM and Gem minimum versions (#3)

### Removed
- Drop support for Rails 3.2 and 4.0 (#39)
- Drop support for Ruby 1.9.x (#24)

### Fixed
- Fix @_page_title uninitialized warning (#62)
- Fix the Travis build on Ruby 2.3.3 (#63)
- Do do not shell-out to `git` in Gemfile (#49)
- Get the tests to run in Rails 4.2 and 5.0 (#40)
- Stop requiring version from the main class (#47)
- Allow the Rails 3.2 build to fail only with Ruby 2.2 (#30)
- Allow Rails 3.2 builds to fail (#26)
- Configure Travis for better performance (#10)
- Remove Gemfile.lock (#1)
