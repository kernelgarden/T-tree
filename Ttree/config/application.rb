require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ttree
  class Application < Rails::Application
config.time_zone = 'Seoul'
config.active_record.default_timezone = :local
  end
end
