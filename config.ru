require 'bundler'

# Ensure RACK_ENV always has a sensible default so the application boots even
# when the environment variable is not provided (e.g., local rackup).
rack_env = ENV.fetch('RACK_ENV', 'development')
Bundler.require(:default, rack_env.to_sym)
ENV['RACK_ENV'] ||= rack_env
begin
  use Rack::LiveReload, no_swf: true
rescue
  nil
end

require File.expand_path(File.join('..','webapp'), __FILE__)
run WebApp
