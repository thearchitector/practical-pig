# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "practical/pig/version"

Gem::Specification.new do |spec|
  spec.name        = "practical-pig"
  spec.version     = PracticalPig::VERSION
  spec.author      = "Elias Gabriel"
  spec.email       = "me@eliasfgabriel.com"
  spec.homepage    = "https://github.com/thearchitector/practical-pig"
  spec.license     = "MIT"

  spec.summary     = <<~HEREDOC.gsub(/[[:space:]]+/, " ").strip
    An opinionated and robust Ruby on Rails application template using RuboCop and pnpm.
  HEREDOC
  spec.description = <<~HEREDOC.gsub(/[[:space:]]+/, " ").strip
    Practical Pig is an opinionated Ruby on Rails template that makes use of webpacker-pnpm, RuboCop, and Prettier to provide a simple yet robust foundation for any web application.
  HEREDOC

  spec.metadata    = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "#{spec.homepage}/tree/v#{spec.version}",
    "changelog_uri" => "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues"
  }

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "rails", ">= 5.2"
  spec.add_dependency "thor"

  spec.bindir      = "bin"
  spec.executables = ["pig"]

  spec.files = `git ls-files`.split("\n")
end
