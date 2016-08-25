# Load the Rails application.
require_relative 'application'
begin
  Tire.configure do
    logger STDERR
    url Settings.elasticsearch_url
  end
rescue=>e
  p "Wrong configuration:#{e}"
end
# Initialize the Rails application.
Rails.application.initialize!
