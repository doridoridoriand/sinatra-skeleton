ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:default, :test)

require 'rack/test'
require 'rspec'

require File.expand_path('../../webapp', __FILE__)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  
  def app
    WebApp
  end
end
