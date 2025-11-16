# セキュリティ強化: セッション管理とCSRF/XSS対策の実装

## ラベル
`security`, `enhancement`

## 優先度
🔴 高（セキュリティに直結するため）

## 概要
現在のアプリケーションでは基本的なセキュリティ対策が不足しています。

## 現状の問題
- セッション管理が `enable :sessions` のみで、セキュアな設定がない
- CSRF（クロスサイトリクエストフォージェリ）対策が未実装
- XSS（クロスサイトスクリプティング）対策が未実装
- 入力値のバリデーションが不足

## 改善策

### 1. セッションのセキュリティ設定を強化
```ruby
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
```

### 2. CSRF対策の実装
```ruby
use Rack::Protection
use Rack::Protection::AuthenticityToken
```

### 3. 入力値のバリデーション追加
- フォーム入力の検証
- パラメータのホワイトリスト化

### 4. XSS対策の実装
- Slimテンプレートのエスケープ設定確認
- ユーザー入力のサニタイズ

## 参考資料
- [Sinatra Security](http://sinatrarb.com/faq.html#security)
- [Rack::Protection](https://github.com/sinatra/sinatra/tree/master/rack-protection)

## チェックリスト
- [ ] セッション設定の強化
- [ ] Rack::Protection の導入
- [ ] 環境変数管理（SESSION_SECRET）
- [ ] CSRF トークンの実装
- [ ] 入力バリデーションの実装
- [ ] テストの作成
- [ ] ドキュメント更新

