# frozen_string_literal: true

require "thor"
require "rails"
require "etc"
require "bundler"

module PracticalPig
  class AppGenerator < Thor
    include Thor::Actions

    desc "new APP_PATH", "Generates a Practical Pig Rails application template."
    long_desc <<~HEREDOC
      `pig new` will generate a new Ruby on Rails application and modify it
      to adhere to Practical Pig's application design guidelines.

      The APP_PATH you provide will be used as the path of the application during
      creation, with its name being the basename (last part of the path). In every
      case, the new application will be generated relative to the current working
      directory (where you execute this command).

      By design, your application must start and end with an alphanumeric character.

      This command makes use of `rails new` under the hood but does not accept
      any generator options.
    HEREDOC
    def new(app_path)
      generate(app_path)
    end

    def self.exit_on_failure?
      true
    end

    def self.source_root
      File.join(__dir__, "../../template")
    end

    private

    APP_NAME_REGEX = /^[a-z].*[a-z0-9]$/i.freeze
    private_constant :APP_NAME_REGEX

    def rails_version_specifier(gem_version=Rails.gem_version)
      if gem_version.segments.size == 3 || gem_version.release.segments.size == 3
        "~> #{gem_version}"
      else
        patch = gem_version.segments[0, 3].join(".")
        "~> #{patch}\", \">= #{gem_version}"
      end
    end

    def generate(app_path)
      if Thor::HELP_MAPPINGS.include?(app_path) || !app_path.match?(APP_NAME_REGEX)
        help("new")
        exit(false)
      end

      system(
        <<~CMD.gsub(/[[:space:]]+/, " ").strip
          rails new #{app_path} -GMPCSJB --database=mysql --skip-gemfile
          --skip-keeps --skip-action-mailbox --skip-action-text --skip-active-storage
          --skip-turbolinks --skip-system-test --skip-webpack-install
        CMD
      )

      app_root = File.join(Dir.pwd, app_path)

      remove_file(File.join(app_root, "config/initializers/content_security_policy.rb"))
      directory(".", app_root, exclude_pattern: /config\/webpack/)

      inside(app_root) do
        gsub_file("Gemfile", "{RUBY_VERSION}", RUBY_VERSION)
        gsub_file("Gemfile", "{RAILS_VERSION}", rails_version_specifier)
        gsub_file("package.json", "{APP_NAME}", File.basename(app_path))

        remove_file("app/assets/config")
        remove_file("app/assets/stylesheets/application.css")

        run("pnpm upgrade", capture: true)

        cmd = Gem.bin_path("bundler", "bundle")
        Bundler.with_original_env do
          run("#{Gem.ruby} #{cmd} install --jobs=#{Etc.nprocessors}", capture: true)

          run("#{Gem.ruby} #{cmd} exec rake webpacker:install", capture: true)
        end

        gsub_file("config/webpacker.yml", "app/javascript", "app/assets")

        remove_file("config/webpack")
      end

      directory("config/webpack", app_root)
    end
  end
end