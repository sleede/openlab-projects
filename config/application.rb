require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'elasticsearch/rails/instrumentation'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Openfablab
  class Application < Rails::Application
    config.i18n.default_locale = :fr
    config.time_zone = 'Paris'
  end
end
