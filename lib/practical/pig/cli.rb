# frozen_string_literal: true

require "thor"
require "rails/gem_version"
require "active_support/core_ext/string/filters"
require "active_support/core_ext/string/inflections"

require "etc"
require "bundler"

module PracticalPig
  class AppGenerator < Thor
    include Thor::Actions

    APP_NAME_REGEX = /^[a-z].*[a-z0-9]$/i.freeze
    private_constant :APP_NAME_REGEX

    attr_accessor :app_root, :app_name

    desc "new APP_PATH", "Generates a Practical Pig Rails application template."
    long_desc <<~HEREDOC
      `pig new` will generate a new Ruby on Rails application and modify it
      to adhere to Practical Pig's application design guidelines.

      The APP_PATH you provide will be used as the path of the application during
      creation, with its name being the basename (last part of the path). In every
      case, the new application will be generated relative to the current working
      directory (where you execute this command).

      By design, your application name must start and end with an alphanumeric character.

      This command makes use of `rails new` under the hood but does not accept
      any generator options.
    HEREDOC
    def new(app_path)
      if Thor::HELP_MAPPINGS.include?(app_path) || flag = !app_path.match?(APP_NAME_REGEX)
        if flag
          say <<~MSG.squish
            \e[31mBy design, your application name must start and end with an alphanumeric
            character.\e[0m
          MSG
          say
        end

        help("new")
        exit(false)
      end

      run(
        <<~CMD.squish
          rails new #{app_path} -GMPCSJB --database=mysql --skip-gemfile
          --skip-keeps --skip-action-mailbox --skip-action-text
          --skip-active-storage --skip-turbolinks --skip-system-test
        CMD
      )

      @app_root = File.join(Dir.pwd, app_path)
      @app_name = File.basename(app_path)

      generate
    end

    def self.source_root
      File.join(__dir__, "../../template")
    end

    def self.exit_on_failure?
      true
    end

    private

    def rails_version_specifier(gem_version=Rails.gem_version)
      if gem_version.segments.size == 3 || gem_version.release.segments.size == 3
        "~> #{gem_version}"
      else
        patch = gem_version.segments[0, 3].join(".")
        "~> #{patch}\", \">= #{gem_version}"
      end
    end

    def generate
      directory(".", app_root, force: true)

      inside(app_root) do
        remove_file("app/assets/config")
        remove_file("app/assets/stylesheets/application.css")
        remove_file("app/views/layouts/application.html.erb")

        run("pnpm upgrade")

        cmd = Gem.bin_path("bundler", "bundle")
        Bundler.with_original_env do
          run("#{Gem.ruby} #{cmd} install --jobs=#{Etc.nprocessors}")

          run("#{Gem.ruby} #{cmd} exec rake webpacker:binstubs")
        end
      end

      say
      say <<~MSG.squish
        \e[32mHooray! Your Practical Pig application (#{app_name}) was generated
          successfully 🥳!\e[0m
      MSG
    end
  end
end