require 'bundler'

# Ensure RACK_ENV always has a sensible default so the application boots even
# when the environment variable is not provided (e.g., local rackup).
# RACK_ENVが未設定の場合、デフォルトで'development'を使用
rack_env = ENV.fetch('RACK_ENV', 'development')

# Bundlerで必要なgemを読み込む（環境に応じて適切なグループを読み込む）
Bundler.require(:default, rack_env.to_sym)

# ENV['RACK_ENV']が未設定の場合は設定
ENV['RACK_ENV'] ||= rack_env

# Twitter Bootstrap用のSinatraプラグインを読み込み
require "sinatra/twitter-bootstrap"

# LiveReload機能を有効化（開発環境での自動リロード用）
# 本番環境ではこのgemが存在しないため、エラーを無視
begin
  use Rack::LiveReload, no_swf: true
rescue
  nil
end

# メインアプリケーションを読み込み
require File.expand_path(File.join('..','webapp'), __FILE__)

# Rackアプリケーションを起動
run WebApp
