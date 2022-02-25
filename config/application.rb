# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Openfablab
  class Application < Rails::Application
    config.i18n.default_locale = :fr
    config.time_zone = 'Paris'

    config.autoloader = :classic

    config.active_record.schema_format = :sql

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
  end
end
