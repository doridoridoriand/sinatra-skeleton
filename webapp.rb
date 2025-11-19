class WebApp < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets
  configure :development do
    register Sinatra::Reloader
    enable :sessions
  end
  configure :production do
    enable :sessions
  end
  configure :test do
    set :protection, false
  end

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
    if settings.development?
      @list = (1..80).map do |i|
        {
          id: i,
          name: Forgery(:name).full_name,
          email: Forgery(:internet).email_address,
          joined: Forgery(:date).date.to_time
        }
      end
    else
      @list = []
    end
    slim :dashboard
  end
end
