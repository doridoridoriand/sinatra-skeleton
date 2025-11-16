# エラーハンドリングの実装

## ラベル
`enhancement`, `user-experience`

## 優先度
🟡 中（ユーザー体験とデバッグのため）

## 概要
現在、404エラーや500エラーなどの適切なエラーハンドリングが実装されていません。

## 現状の問題
- カスタムエラーページがない
- エラー時のログ記録がない
- ユーザーへのフィードバックが不適切
- デバッグ情報が本番環境で露出する可能性がある
- エラーの統一的な処理がない

## 改善策

### 1. エラーハンドラーの実装

#### webapp.rb（基本的なエラーハンドリング）
```ruby
class WebApp < Sinatra::Base
  # 404 Not Found
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
end
```

### 2. カスタムエラーページの作成

#### views/error_404.slim
```slim
.container
  .row
    .col-md-8.col-md-offset-2.text-center
      h1.display-1 404
      h2 ページが見つかりません
      p.lead お探しのページは存在しないか、移動した可能性があります。
      
      .mt-5
        a.btn.btn-primary href="/" トップページに戻る
        |  
        a.btn.btn-secondary href="javascript:history.back()" 前のページに戻る
```

#### views/error_500.slim
```slim
.container
  .row
    .col-md-8.col-md-offset-2.text-center
      h1.display-1 500
      h2 サーバーエラー
      p.lead システムエラーが発生しました。ご迷惑をおかけして申し訳ございません。
      
      - if development?
        .alert.alert-danger.mt-4
          h4 エラー詳細（開発環境のみ）
          pre= @error.message
          pre= @error.backtrace.join("\n")
      
      .mt-5
        a.btn.btn-primary href="/" トップページに戻る
```

#### views/error_validation.slim
```slim
.container
  .row
    .col-md-8.col-md-offset-2
      .alert.alert-warning
        h4 入力エラー
        p= @error_message
      
      a.btn.btn-secondary href="javascript:history.back()" 戻る
```

### 3. 環境別のエラー表示設定

#### config/environments.rb
```ruby
configure :development do
  set :show_exceptions, :after_handler
  set :dump_errors, true
  set :raise_errors, false
end

configure :production do
  set :show_exceptions, false
  set :dump_errors, false
  set :raise_errors, true
  
  # 本番環境ではエラーを外部サービスに送信
  # use Rack::Honeybadger
  # または
  # use Sentry::Rack::CaptureExceptions
end

configure :test do
  set :show_exceptions, false
  set :raise_errors, true
end
```

### 4. エラーロギングの実装

#### helpers/error_helper.rb
```ruby
module ErrorHelper
  def log_error(error, context = {})
    logger.error do
      {
        error_class: error.class.name,
        message: error.message,
        backtrace: error.backtrace&.first(10),
        context: context,
        timestamp: Time.now.iso8601
      }.to_json
    end
  end
  
  def notify_error(error, context = {})
    # エラー通知サービスへの送信
    # Sentry.capture_exception(error, extra: context)
  end
end
```

### 5. カスタム例外クラスの定義

#### lib/errors.rb
```ruby
module MyApp
  class Error < StandardError; end
  
  class ValidationError < Error; end
  class NotFoundError < Error; end
  class UnauthorizedError < Error; end
  class ForbiddenError < Error; end
end
```

#### 使用例
```ruby
get '/dashboard/:id' do
  user = User.find(params[:id])
  raise MyApp::NotFoundError, "User not found" unless user
  
  slim :dashboard, locals: { user: user }
end

# NotFoundErrorのハンドリング
error MyApp::NotFoundError do |e|
  status 404
  slim :error_404
end
```

### 6. Rack::Protectionのエラーハンドリング

```ruby
use Rack::Protection, except: [:json_csrf]

# CSRF検証失敗時のハンドリング
error Rack::Protection::AuthenticityToken::InvalidToken do
  halt 403, slim(:error_csrf)
end
```

### 7. 統一的なエラーレスポンス（API用）

#### helpers/api_helper.rb
```ruby
module ApiHelper
  def api_error(status, message, details = {})
    halt status, json({
      error: {
        status: status,
        message: message,
        details: details,
        timestamp: Time.now.iso8601
      }
    })
  end
  
  def api_success(data, status = 200)
    halt status, json({
      data: data,
      timestamp: Time.now.iso8601
    })
  end
end
```

#### 使用例
```ruby
get '/api/users/:id' do
  content_type :json
  
  user = User.find(params[:id])
  api_error(404, 'User not found') unless user
  
  api_success(user.to_json)
end
```

### 8. エラー監視サービスの統合

#### Gemfile（オプション）
```ruby
# エラートラッキング
gem 'sentry-ruby'
gem 'sentry-rack'
```

#### config/sentry.rb
```ruby
require 'sentry-ruby'

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.environment = ENV['RACK_ENV']
  config.enabled_environments = %w[production staging]
  
  # サンプリングレート
  config.traces_sample_rate = 0.5
end

use Sentry::Rack::CaptureExceptions
```

## 実装手順

### Phase 1: 基本的なエラーハンドラー
- [ ] not_foundハンドラーの実装
- [ ] errorハンドラーの実装
- [ ] 環境別設定の追加

### Phase 2: エラーページの作成
- [ ] 404エラーページ（error_404.slim）
- [ ] 500エラーページ（error_500.slim）
- [ ] その他のエラーページ

### Phase 3: ロギング
- [ ] エラーログの実装
- [ ] ログフォーマットの統一
- [ ] ログローテーション設定

### Phase 4: カスタム例外
- [ ] 例外クラスの定義
- [ ] 例外ハンドラーの実装
- [ ] 既存コードの例外使用への移行

### Phase 5: テスト
- [ ] エラーハンドラーのテスト
- [ ] エラーページの表示テスト
- [ ] ログ出力のテスト

### Phase 6: 監視（オプション）
- [ ] Sentryなどのエラー監視サービス導入
- [ ] アラート設定
- [ ] ダッシュボード設定

## チェックリスト
- [ ] 404エラーハンドラーの実装
- [ ] 500エラーハンドラーの実装
- [ ] カスタムエラーページの作成
- [ ] 環境別エラー表示設定
- [ ] エラーロギングの実装
- [ ] カスタム例外クラスの定義
- [ ] Rack::Protectionエラーハンドリング
- [ ] API用エラーレスポンスの統一
- [ ] テストの作成
- [ ] ドキュメントの更新

## エラーハンドリングのベストプラクティス

1. **本番環境ではスタックトレースを表示しない**
   - セキュリティリスク
   - ユーザーフレンドリーではない

2. **すべてのエラーをログに記録**
   - デバッグに必要
   - パターン分析に有用

3. **ユーザーに適切なメッセージを表示**
   - 技術的な詳細は避ける
   - 次のアクションを提示

4. **エラーを分類する**
   - 4xx: クライアントエラー
   - 5xx: サーバーエラー

5. **エラー監視を導入**
   - リアルタイムでエラーを把握
   - エラー率の監視

## 参考資料
- [Sinatra Error Handling](http://sinatrarb.com/intro.html#Error%20Handling)
- [Rack::Protection](https://github.com/sinatra/sinatra/tree/master/rack-protection)
- [Sentry for Ruby](https://docs.sentry.io/platforms/ruby/)
- [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

