source "https://rubygems.org"

gem "sinatra", require: "sinatra/base"
gem "sinatra-contrib", require: "sinatra/reloader"

gem "slim"
gem "redcarpet"
gem "sass"
gem "sinatra-twitter-bootstrap" # need `require "sinatra/twitter-bootstrap"` in config.ru

group :development do
  if RUBY_VERSION >= '2.0.0'
    gem "pry-byebug"
  else
    gem "pry-debugger"
  end
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "tapp"

  gem "rspec"

  gem "thin", require: false
  gem "guard", "~> 2.0", require: false
  gem "guard-shotgun"
  gem "rack-livereload"
  gem "guard-livereload", require: false

  gem "forgery"
end
