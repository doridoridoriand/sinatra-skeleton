source "https://rubygems.org"

gem "sinatra", require: "sinatra/base"
gem "sinatra-contrib", require: "sinatra/reloader"

gem "slim"
gem "redcarpet"
gem "sass"
gem "rack-protection"
gem "rack", "~> 3.2"

group :development do
  gem "byebug", "~> 11.1"



  gem "tapp"

  gem "thin", require: false
  gem "guard", "~> 2.0", require: false
  gem "lumberjack", "~> 1.2"
  gem "guard-shotgun"
  gem "rack-livereload"
  gem "guard-livereload", require: false

  gem "eventmachine", "~> 1.2"
  gem "ffi", "~> 1.17"
  gem "forgery"
end

group :test do
  gem "rspec"
  gem "rack-test"
end
