require_relative 'lib/errors'

class WebApp < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets
  configure :development do
    register Sinatra::Reloader
  end

  configure :test do
    set :protection, false
  end

  # セッションのセキュリティ設定を強化
  configure do
    # Note: SESSION_SECRET must be set in production to persist sessions across restarts
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    use Rack::Session::Cookie,
      key: 'rack.session',
      path: '/',
      httponly: true,
      secure: production?,
      same_site: :lax,
      secret: settings.session_secret
  end

  # CSRF対策の実装
  use Rack::Protection
  use Rack::Protection::AuthenticityToken

  # エラーハンドリングの実装
  not_found do
    @title = "ページが見つかりません"
    status 404

    if request.xhr?
      # Ajaxリクエストの場合
      json error: 'Not Found', status: 404
    else
      slim :error_404, layout: :layout_1col
    end
  end

  # 500 Internal Server Error
  error do
    @error = env['sinatra.error']
    @title = "エラーが発生しました"
    status 500

    # ログ記録
    logger.error "Error: #{@error.message}"
    logger.error @error.backtrace.join("\n")

    if request.xhr?
      json error: 'Internal Server Error', status: 500
    else
      slim :error_500, layout: :layout_1col
    end
  end

  # 特定のエラーハンドリング
  error Sinatra::NotFound do
    not_found
  end

  # カスタムエラー
  error MyApp::ValidationError do |e|
    @title = "入力エラー"
    @error_message = e.message
    status 422
    slim :error_validation
  end

  error MyApp::NotFoundError do |e|
    status 404
    slim :error_404
  end

  error MyApp::UnauthorizedError do |e|
    status 401
    slim :error_401
  end

  error MyApp::ForbiddenError do |e|
    status 403
    slim :error_403
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
