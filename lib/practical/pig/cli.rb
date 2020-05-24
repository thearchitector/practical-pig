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

    NAME_PATTERN = /^[a-z].*[a-z0-9]$/i.freeze
    private_constant :NAME_PATTERN

    attr_accessor :app_name

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
    option :quiet, type: :boolean, aliases: "-q", desc: "Suppress status output"
    option :with_hmr, type: :boolean, desc: "Install Webpack HMR development server"
    def new(app_path)
      # ensure that applications are not requests for help, or that their names follow the
      # appropriate format
      if Thor::HELP_MAPPINGS.include?(app_path) || (flag = !app_path.match?(NAME_PATTERN))
        if flag
          say <<~MSG.squish
            \e[31mBy design, your application name must start and end with an alphanumeric
            character.\e[0m
          MSG
          say
        end

        help("new")
        return
      end

      # generate a Rails application, omitting many things
      run(
        <<~CMD.squish
          rails new #{app_path} -GMPCSJB --database=postgresql --skip-gemfile --skip-keeps
          #{" --quiet" if options[:quiet]} --skip-action-mailbox --skip-system-test
          --skip-action-text --skip-active-storage --skip-turbolinks
        CMD
      )

      app_root = File.join(Dir.pwd, app_path)
      @app_name = File.basename(app_root)

      generate(app_root)
    end

    def self.source_root
      File.join(__dir__, "../../template")
    end

    def self.exit_on_failure?
      true
    end

    private

    def generate(app_root)
      # copy all files from PP's template app, evaluating ERBs and forcing
      # file overwrites
      directory(".", app_root, force: true)

      inside(app_root) do
        remove_file("app/assets/config")
        remove_file("app/assets/stylesheets/application.css")
        remove_file("app/views/layouts/application.html.erb")

        # concurrently install all JS dependencies using pnpm
        run("pnpm i --child-concurrency=#{Etc.nprocessors}", capture: options[:quiet])
        run("pnpm add webpack-dev-server --save-dev") if options[:with_hmr]

        # get the system-wide Bundler gem and, within the local environment (application),
        # concurrently install all Ruby gems. we do it in a separate bundler environment
        # because we don't want cross-talk between pig and app dependencies
        cmd = "#{Gem.ruby} #{Gem.bin_path("bundler", "bundle")}"
        Bundler.with_unbundled_env do
          run("#{cmd} install --jobs=#{Etc.nprocessors}", capture: options[:quiet])

          # install Webpacker's binstubs
          run("#{cmd} exec rake webpacker:binstubs", capture: options[:quiet])
          remove_file("bin/webpack-dev-server") unless options[:with_hmr]
        end
      end

      print_output
    end

    def print_output
      # say a nice thing
      if options[:quiet]
        say <<~MSG.squish
          \e[90mYour Practical Pig application (#{app_name}) was generated successfully
          (and quietly)!\e[0m 🤫
        MSG
      else
        say
        say
        say <<~MSG.squish
          \e[32mHooray! Your Practical Pig application (#{app_name}) was generated
          successfully!\e[0m 🥳
        MSG
        # because PP copies a static package.json and pnpm, it is possible that new
        # applications will have an outdated version in their dependency list. to
        # help mitigate that, output a message making users aware of the possibility
        say <<~MSG
          \e[90m> Your application's dependencies might be out of date.\e[0m
          \e[90m> To safely update, run `bundle update --conservative` and `pnpm up`.\e[0m
          \e[90m> To forcefully update, run `bundle update` and `pnpm up -L`.\e[0m
        MSG
        say
      end
    end

    # https://github.com/rails/rails/blob/master/railties/lib/rails/generators/app_base.rb#L300-L311
    def rails_version_specifier(gem_version = Rails.gem_version)
      if gem_version.segments.size == 3 || gem_version.release.segments.size == 3
        "~> #{gem_version}"
      else
        patch = gem_version.segments[0, 3].join(".")
        "~> #{patch}\", \">= #{gem_version}"
      end
    end
  end
end
