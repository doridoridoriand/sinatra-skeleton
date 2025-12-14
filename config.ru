require 'bundler'

rack_env = ENV.fetch('RACK_ENV', 'development').to_sym
Bundler.require(:default, rack_env)
require "sinatra/twitter-bootstrap"
begin
  use Rack::LiveReload, no_swf: true
rescue
  nil
end

# メインアプリケーションを読み込み
require File.expand_path(File.join('..','webapp'), __FILE__)

# Rackアプリケーションを起動
run WebApp
