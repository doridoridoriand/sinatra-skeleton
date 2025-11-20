class WebApp < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets
  configure :development do
    register Sinatra::Reloader
  end

  # Secure session configuration
  configure do
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    use Rack::Session::Cookie,
      key: 'rack.session',
      path: '/',
      httponly: true,
      secure: production?,
      same_site: :lax,
      secret: settings.session_secret
  end

  # Enable Rack::Protection for CSRF and other security protections
  use Rack::Protection
  use Rack::Protection::AuthenticityToken

  get "/css/application.css" do
    sass :application
  end

  get "/" do
    @title = "Welcome"
    slim :index, :layout => :layout_1col
  end

  get "/dashboard" do
    @title = "Dashboard"
    # generate random data for demo.
    @list = (1..80).map do |i|
      {
        id: i,
        name: Forgery(:name).full_name,
        email: Forgery(:internet).email_address,
        joined: Forgery(:date).date.to_time
      }
    end
    slim :dashboard
  end
end
