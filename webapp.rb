# カスタムエラークラスを読み込み
require_relative 'lib/errors'

# メインアプリケーションクラス
# Sinatra::Baseを継承してモジュラースタイルのアプリケーションを構築
class WebApp < Sinatra::Base
  # Twitter Bootstrap用アセットパイプラインを登録
  register Sinatra::Twitter::Bootstrap::Assets
  
  # 開発環境用の設定
  configure :development do
    # ファイル変更時の自動リロード機能を有効化
    register Sinatra::Reloader
  end

  # テスト環境用の設定
  configure :test do
    # テスト実行時はRack::Protectionを無効化
    # （CSRFトークンのチェックをスキップするため）
    set :protection, false
  end

  # セッションのセキュリティ設定を強化
  configure do
    # セッションシークレットキーの設定
    # 本番環境では環境変数SESSION_SECRETを必ず設定すること
    # 開発環境では未設定の場合、ランダムな値を自動生成
    # Note: SESSION_SECRET must be set in production to persist sessions across restarts
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    
    # Rack::Session::Cookieを使用したセキュアなセッション管理
    use Rack::Session::Cookie,
      key: 'rack.session',       # セッションCookieの名前
      path: '/',                  # Cookieの有効パス
      httponly: true,             # JavaScriptからのアクセスを防止（XSS対策）
      secure: production?,        # 本番環境ではHTTPS接続のみでCookieを送信
      same_site: :lax,           # クロスサイトリクエスト時の挙動を制御（CSRF緩和）
      secret: settings.session_secret
  end

  # CSRF対策の実装
  # Rack::Protectionで一般的な攻撃から保護
  use Rack::Protection
  # フォーム送信時のCSRFトークン検証を有効化
  use Rack::Protection::AuthenticityToken

  # エラーハンドリングの実装
  # 404 Not Found - ページが見つからない場合のエラーハンドラ
  not_found do
    @title = "ページが見つかりません"
    status 404

    if request.xhr?
      # Ajaxリクエストの場合はJSON形式でエラーを返す
      json error: 'Not Found', status: 404
    else
      # 通常のリクエストの場合はエラーページを表示
      slim :error_404, layout: :layout_1col
    end
  end

  # 500 Internal Server Error - サーバー内部エラーのハンドラ
  error do
    @error = env['sinatra.error']
    @title = "エラーが発生しました"
    status 500

    # エラー情報をログに記録
    logger.error "Error: #{@error.message}"
    logger.error @error.backtrace.join("\n")

    if request.xhr?
      # Ajaxリクエストの場合はJSON形式でエラーを返す
      json error: 'Internal Server Error', status: 500
    else
      # 通常のリクエストの場合はエラーページを表示
      slim :error_500, layout: :layout_1col
    end
  end

  # 特定のエラーハンドリング
  # Sinatra::NotFoundエラーを404ハンドラにリダイレクト
  error Sinatra::NotFound do
    not_found
  end

  # カスタムエラーのハンドリング
  # バリデーションエラー（入力値の検証失敗時）
  error MyApp::ValidationError do |e|
    @title = "入力エラー"
    @error_message = e.message
    status 422  # Unprocessable Entity
    slim :error_validation
  end

  # リソースが見つからないエラー
  error MyApp::NotFoundError do |e|
    status 404
    slim :error_404
  end

  # 認証が必要なエラー（未ログイン状態でのアクセスなど）
  error MyApp::UnauthorizedError do |e|
    status 401  # Unauthorized
    slim :error_401
  end

  # アクセス権限がないエラー（ログイン済みだが権限不足）
  error MyApp::ForbiddenError do |e|
    status 403  # Forbidden
    slim :error_403
  end

  # CSSファイルの生成エンドポイント
  # SassファイルをコンパイルしてCSSとして返す
  get "/css/application.css" do
    sass :application
  end

  # ルートパス - トップページ
  get "/" do
    @title = "Welcome"
    slim :index, :layout => :layout_1col
  end

  # ダッシュボードページ
  get "/dashboard" do
    @title = "Dashboard"
    
    # デモ用のランダムデータを生成（開発環境のみ）
    if settings.development?
      @list = (1..80).map do |i|
        {
          id: i,
          name: Forgery(:name).full_name,           # ランダムな名前
          email: Forgery(:internet).email_address,  # ランダムなメールアドレス
          joined: Forgery(:date).date.to_time       # ランダムな日付
        }
      end
    else
      # 本番環境では空のリストを返す
      @list = []
    end
    slim :dashboard
  end
end
