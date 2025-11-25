source "https://rubygems.org"

gem "sinatra", require: "sinatra/base"
gem "sinatra-contrib", require: "sinatra/reloader"

gem "slim"
gem "redcarpet"
gem "sass"
gem "rack-protection"

group :development do
  gem "byebug", "~> 11.1"
  gem "pry-rescue"
  gem "tapp"

  gem "thin", require: false
  gem "guard", "~> 2.0", require: false
  gem "guard-shotgun"
  gem "rack-livereload"
  gem "guard-livereload", require: false

  gem "forgery"
  gem "eventmachine", "~> 1.2"
  gem "ffi", "~> 1.15"
end

group :test do
  gem "rspec"
  gem "rack-test"
end
