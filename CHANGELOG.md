# Page title helper change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/).

Read more at [Keep a CHANGELOG](https://keepachangelog.com/en/0.3.0/)
about why a change log is important.


## x.y.z

### Added
- Officially support Ruby 2.7
  ([#103](https://github.com/lwe/page_title_helper/pull/103))

### Changed

### Deprecated

### Removed
- Drop support for Rails < 5.2
  ([#104](https://github.com/lwe/page_title_helper/pull/104))

### Fixed

### Security

## 4.0.0

### Added
- Add support for Rails 6.0
  ([#94](https://github.com/lwe/page_title_helper/pull/94))

### Removed
- Drop support for Ruby < 2.4
  ([#93](https://github.com/lwe/page_title_helper/pull/93))

## 3.0.0

### Added
- Add Ruby 2.4.0 to the build matrix
  ([#68](https://github.com/lwe/page_title_helper/pull/68))
- Add a CHANGELOG.md
  ([#59](https://github.com/lwe/page_title_helper/pull/59))
- Add RuboCop checking to the CI
  ([#52](https://github.com/lwe/page_title_helper/pull/52))
- Add a CODE_OF_CONDUCT.md
  ([#51](https://github.com/lwe/page_title_helper/pull/51))
- Update Ruby to 2.3.3 and 2.2.6 on Travis
  ([#38](https://github.com/lwe/page_title_helper/pull/38))
- Add Ruby 2.3.0 to the build matrix
- Re-add Ruby 2.0.0 to the build matrix
  ([#29](https://github.com/lwe/page_title_helper/pull/29))
- Test against Ruby 2.2
- Use Appraisal for building with different Rails versions
  ([#19](https://github.com/lwe/page_title_helper/pull/19))

### Changed
- Replaced Appraisals with specific Gemfiles
  ([#41](https://github.com/lwe/page_title_helper/pull/41))
- Delete obsolete init.rb file
  ([#61](https://github.com/lwe/page_title_helper/pull/61))
- Add Rails 5.0 to the build matrix
  ([#42](https://github.com/lwe/page_title_helper/pull/42))
- Raise RVM and Gem minimum versions
  ([#3](https://github.com/lwe/page_title_helper/pull/3))

### Removed
- Drop support for Rails 3.2 and 4.0
  ([#39](https://github.com/lwe/page_title_helper/pull/39))
- Drop support for Ruby 1.9.x
  ([#24](https://github.com/lwe/page_title_helper/pull/24))

### Fixed
- Fix @_page_title uninitialized warning
  ([#62](https://github.com/lwe/page_title_helper/pull/62))
- Fix the Travis build on Ruby 2.3.3
  ([#63](https://github.com/lwe/page_title_helper/pull/63))
- Do do not shell-out to `git` in Gemfile
  ([#49](https://github.com/lwe/page_title_helper/pull/49))
- Get the tests to run in Rails 4.2 and 5.0
  ([#40](https://github.com/lwe/page_title_helper/pull/40))
- Stop requiring version from the main class
  ([#47](https://github.com/lwe/page_title_helper/pull/47))
- Allow the Rails 3.2 build to fail only with Ruby 2.2
  ([#30](https://github.com/lwe/page_title_helper/pull/30))
- Allow Rails 3.2 builds to fail
  ([#26](https://github.com/lwe/page_title_helper/pull/26))
- Configure Travis for better performance
  ([#10](https://github.com/lwe/page_title_helper/pull/10))
- Remove Gemfile.lock
  ([#1](https://github.com/lwe/page_title_helper/pull/1))
