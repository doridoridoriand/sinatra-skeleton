# カスタムエラークラスを読み込み
require "securerandom"
require_relative 'lib/errors'

# メインアプリケーションクラス
# Sinatra::Baseを継承してモジュラースタイルのアプリケーションを構築
class WebApp < Sinatra::Base
  PROJECTS_MUTEX = Mutex.new
  use Rack::MethodOverride

  # 開発環境用の設定
  configure :development do
    # Sinatraのデフォルト例外ページではなくカスタムハンドラを使う
    set :show_exceptions, :after_handler
    set :dump_errors, true
    set :raise_errors, false
    # ファイル変更時の自動リロード機能を有効化
    register Sinatra::Reloader
  end

  # 本番環境用の設定
  configure :production do
    set :show_exceptions, false
    set :dump_errors, false
    set :raise_errors, false
  end

  # テスト環境用の設定
  configure :test do
    # テスト実行時はRack::Protectionを無効化
    # （CSRFトークンのチェックをスキップするため）
    set :protection, false
    set :show_exceptions, false
    set :raise_errors, false
  end

  # セッションのセキュリティ設定を強化
  configure do
    set :erb, escape_html: true
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

    # NOTE: In-memory store for development/demo only. Not thread-safe in production; swap with DB.
    set :projects, [
      { id: 1, name: "Customer Discovery", owner: "Product", status: "In Progress", description: "Interview and synthesize pain points before the next planning cycle." },
      { id: 2, name: "Design System Refresh", owner: "Design", status: "Planned", description: "Lightweight refresh of spacing, color tokens, and form components." },
      { id: 3, name: "Metrics Dashboard", owner: "Data", status: "Blocked", description: "Ship a self-serve KPI dashboard; blocked waiting on tracking plan." },
    ]
    set :next_project_id, 4
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
      erb :error_404, layout: :layout_1col
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
      erb :error_500, layout: :layout_1col
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
    erb :error_validation, layout: :layout_1col
  end

  # リソースが見つからないエラー
  error MyApp::NotFoundError do |e|
    status 404
    erb :error_404, layout: :layout_1col
  end

  # 認証が必要なエラー（未ログイン状態でのアクセスなど）
  error MyApp::UnauthorizedError do |e|
    status 401  # Unauthorized
    erb :error_401, layout: :layout_1col
  end

  # アクセス権限がないエラー（ログイン済みだが権限不足）
  error MyApp::ForbiddenError do |e|
    status 403  # Forbidden
    erb :error_403, layout: :layout_1col
  end

  # CSRFトークン検証失敗時のハンドリング
  # rack-protection 4.x では、CSRF検証失敗時に例外をスローせず、
  # 直接403レスポンスを返すため、このエラーハンドラーは不要になりました。
  # 必要に応じて、403ステータスのハンドラーで対応してください。
  # error Rack::Protection::InvalidToken do |e|
  #   @title = "不正なリクエストです"
  #   logger.warn "CSRF token validation failed: #{e.message}"
  #   status 403
  #
  #   if request.xhr?
  #     json error: 'Forbidden', status: 403
  #   else
  #     erb :error_csrf, layout: :layout_1col
  #   end
  # end

  helpers do
    def csrf_token
      Rack::Protection::AuthenticityToken.token(session)
    end

    def project_statuses
      ["Planned", "In Progress", "Blocked", "Done"]
    end

    def project_store
      settings.projects
    end

    def next_project_id!
      PROJECTS_MUTEX.synchronize do
        id = settings.next_project_id
        settings.next_project_id = id + 1
        id
      end
    end

    def find_project!(id)
      project_store.find { |p| p[:id] == id } || raise(MyApp::NotFoundError, "Project not found")
    end

    def validate_project!(attrs)
      name = attrs[:name].to_s.strip
      owner = attrs[:owner].to_s.strip
      status = attrs[:status].to_s.strip

      raise MyApp::ValidationError, "プロジェクト名を入力してください。" if name.empty?
      raise MyApp::ValidationError, "担当者を入力してください。" if owner.empty?
      raise MyApp::ValidationError, "ステータスを選択してください。" if status.empty?
      raise MyApp::ValidationError, "不正なステータスです。" unless project_statuses.include?(status)
    end

    def project_params
      status = params[:status].to_s.strip
      status = "Planned" if status.empty?

      {
        name: params[:name].to_s.strip,
        owner: params[:owner].to_s.strip,
        status: status,
        description: params[:description].to_s.strip
      }
    end
  end

  # CSSファイルの生成エンドポイント
  # SassファイルをコンパイルしてCSSとして返す
  get "/css/application.css" do
    sass :application
  end

  # ルートパス - トップページ
  get "/" do
    @title = "Welcome"
    erb :index, layout: :layout_1col
  end

  # ダッシュボードページ
  get "/dashboard" do
    @title = "Dashboard"

    @projects = project_store
    @recent_people =
      if settings.development?
        (1..12).map do
          {
            name: Forgery(:name).full_name,
            role: %w[PM Designer Engineer Analyst].sample,
            joined: Forgery(:date).date.to_time
          }
        end
      else
        []
      end
    erb :dashboard
  end

  # Projects CRUD
  get "/projects" do
    @title = "Projects"
    @active_status_filter = params[:status]
    @projects = if @active_status_filter && project_statuses.include?(@active_status_filter)
      project_store.select { |p| p[:status] == @active_status_filter }
    else
      project_store
    end
    erb :"projects/index"
  end

  get "/projects/new" do
    @title = "New project"
    @project = { status: "Planned" }
    erb :"projects/new"
  end

  post "/projects" do
    attrs = project_params
    validate_project!(attrs)

    project = PROJECTS_MUTEX.synchronize do
      attrs.merge(id: next_project_id!).tap { |p| project_store << p }
    end
    redirect "/projects/#{project[:id]}?created=1"
  end

  get "/projects/:id" do
    @project = find_project!(params[:id].to_i)
    @title = @project[:name]
    erb :"projects/show"
  end

  get "/projects/:id/edit" do
    @project = find_project!(params[:id].to_i)
    @title = "#{@project[:name]} を編集"
    erb :"projects/edit"
  end

  patch "/projects/:id" do
    attrs = project_params
    validate_project!(attrs)

    PROJECTS_MUTEX.synchronize do
      project = find_project!(params[:id].to_i)
      project.merge!(attrs)
      redirect "/projects/#{project[:id]}?updated=1"
    end
  end

  delete "/projects/:id" do
    PROJECTS_MUTEX.synchronize do
      project = find_project!(params[:id].to_i)
      project_store.delete_if { |p| p[:id] == project[:id] }
    end
    redirect "/projects?deleted=1"
  end

  # テスト用ヘルパールート（本番環境では無効）
  if settings.test?
    get "/__spec__/trigger_error" do
      raise StandardError, "Intentional error for test"
    end

    get "/__spec__/trigger_csrf_error" do
      raise Rack::Protection::AuthenticityToken::InvalidToken, "Invalid token for test"
    end
  end
end
