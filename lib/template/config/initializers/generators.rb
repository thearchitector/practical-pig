# frozen_string_literal: true

Rails.application.config.generators do |g|
  # Disable creation of default generators
  g.stylesheets(false)
  g.javascripts(false)
  g.scaffold_stylesheet(false)

  # Specify Slim as the templating engine
  g.template_engine(:slim)
end
