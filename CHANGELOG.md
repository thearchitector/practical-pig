# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog (<https://keepachangelog.com/en/1.0.0/>). This project adheres to Semantic Versioning (<https://semver.org/spec/v2.0.0.html>).

## [v1.0.0] - 2020-05-23

### Added

- Gem specifications and foundational files, generated by Bundler v2.1.4, for defining a Ruby gem.
- `pig` command for invoking `PracticalPig::CLI` methods.
- `new` CLI command for generating Practical Pig-based Rails applications, based on `rails new`.
- Sparse application template with pre-configured gem and Webpacker environments (using `webpacker-pnpm`).
- Exposed RuboCop config for use in dependent gems.
- Travis config for CLI and environment testing.