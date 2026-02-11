# Sinatra Skeleton

Sinatraを使用したWebアプリケーションのスケルトンプロジェクトです。モダンな開発ツールとセキュリティ対策を組み込んだ、すぐに使える開発環境を提供します。

## 📋 目次

- [プロジェクト概要](#プロジェクト概要)
- [主な機能](#主な機能)
- [技術スタック](#技術スタック)
- [必要条件](#必要条件)
- [ディレクトリ構成](#ディレクトリ構成)
- [セットアップ](#セットアップ)
- [開発方法](#開発方法)
- [テスト](#テスト)
- [デプロイ](#デプロイ)
- [セキュリティ](#セキュリティ)
- [ライセンス](#ライセンス)
- [コントリビューション](#コントリビューション)

## プロジェクト概要

このプロジェクトは、Sinatraフレームワークを使用したWebアプリケーション開発のための基礎テンプレートです。必要最小限の設定で開発を開始でき、セキュリティ対策や開発効率化ツールが予め組み込まれています。

### 主な機能

- 🔒 セキュアなセッション管理
- 🛡️ CSRF/XSS対策の実装
- 🔄 Guard + LiveReloadによる自動リロード
- 🎨 Bootstrap統合
- ✅ RSpec テストフレームワーク
- 📝 ERBテンプレート
- 🎨 Sassプリプロセッサ
- 🐛 デバッグツール（pry-byebug）

## 技術スタック

- **Ruby** 4.0+ (推奨: 4.0以上)
- **Sinatra** 4.x - 軽量Webフレームワーク
- **ERB** - テンプレートエンジン
- **Sass** 3.x - CSSプリプロセッサ
- **Bootstrap** - UIフレームワーク (sinatra-twitter-bootstrap経由)
- **Rack::Protection** - セキュリティミドルウェア
- **Guard** - 開発時の自動リロード
- **LiveReload** - ブラウザの自動リフレッシュ
- **RSpec** - テストフレームワーク
- **Pry-byebug** - デバッグツール

## 必要条件

- Ruby 4.0以上（推奨: 4.0以上）
- Bundler
- OpenSSL（セッションシークレット生成用）

## ディレクトリ構成

```
.
├── config.ru                # Rackアプリケーション設定ファイル
├── webapp.rb                # メインアプリケーション（ルート定義）
├── Gemfile                  # gem依存関係の定義
├── Gemfile.lock             # gemバージョンのロック
├── Guardfile                # Guard設定（自動リロード）
├── .env.example             # 環境変数のサンプル
├── config.rb                # アプリケーション設定（該当する場合）
├── lib/                     # ライブラリ・ヘルパーファイル
│   └── errors.rb           # カスタムエラークラス定義
├── views/                   # ERBテンプレートファイル
│   ├── layout.erb           # 基本レイアウト
│   ├── layout_1col.erb      # 1カラムレイアウト
│   ├── index.erb            # トップページ
│   ├── dashboard.erb        # ダッシュボード
│   ├── projects/*.erb       # プロジェクトCRUD用テンプレート
│   ├── application.sass     # アプリケーションスタイル
│   └── error_*.erb          # エラーページテンプレート
├── spec/                    # テストファイル
│   ├── spec_helper.rb      # RSpec設定
│   └── requests/           # リクエストスペック
├── README.md                # このファイル
├── CONTRIBUTING.md          # コントリビューションガイド
├── CHANGELOG.md             # 変更履歴
├── LICENSE                  # ライセンス情報
└── IMPROVEMENT_DOCUMENTATION.md  # 改善点ドキュメント
```

## セットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/doridoridoriand/sinatra-skeleton.git
cd sinatra-skeleton
```

### 2. 依存関係のインストール

```bash
# gemをローカルディレクトリにインストール（推奨）
bundle config set --local path '.bundle/gems'

# 並列でgemをインストール
bundle install --jobs 4
```

### 3. 環境変数の設定

本番環境では必ずセッションシークレットを設定してください：

```bash
# .env.exampleを参考に.envファイルを作成
cp .env.example .env

# SESSION_SECRETを生成して設定（必須）
export SESSION_SECRET=$(openssl rand -hex 64)
```

**注意**: 開発環境では環境変数が未設定の場合、自動的にランダムな値が生成されますが、本番環境では必ず設定してください。

## 開発方法

### アプリケーションの起動

開発サーバーは `bundle exec guard -i` で起動できますが、プロダクションやシンプルな起動には `bundle exec thin start -R config.ru -p 3333 -e production` も使用できます。ファイルの変更を検知して自動的にリロードされます：

```bash
# 開発時（Guard + LiveReload）
bundle exec guard -i

# 本番またはシンプル起動
bundle exec thin start -R config.ru -p 3333 -e production
```

ブラウザで `http://localhost:3333` にアクセスしてください。

### Guardの機能

- **自動リロード**: `webapp.rb`、`config.ru`、`views/`配下のファイルの変更を検知
- **LiveReload**: ブラウザを自動的にリフレッシュ
- **Thin サーバー**: 高速な開発用Webサーバー

### デバッグ方法

コード中に`binding.pry`を挿入することで、pry-byebugデバッガーを使用できます：

```ruby
def some_method
  binding.pry  # ここで実行が停止し、対話的にデバッグできます
  # ...
end
```

## テスト

### テストの実行

```bash
# developmentグループのgemを除外してテストを実行
bundle config set --local without 'development'
bundle exec rspec
```

### テストの書き方

`spec/requests/` ディレクトリにリクエストスペックを配置します。詳細は既存のテストファイルを参照してください。

## デプロイ

### 本番環境の設定

1. **環境変数の設定**

```bash
export RACK_ENV=production
export SESSION_SECRET=your_secure_random_secret_key_here
```

2. **gemのインストール（本番環境用）**

```bash
bundle config set --local without 'development test'
bundle install --deployment
```

### Docker

```bash
# ビルド (IMAGE_NAMEでタグ指定、デフォルト: sinatra-skeleton:dev)
bundle exec rake docker:build

# マルチアーキのビルド&push（REGISTRY_IMAGEなどはtools/release.sh参照）
bundle exec rake docker:release
```

3. **Rackサーバーの起動**

Passenger、Puma、Unicornなど、お好みのRackサーバーを使用できます：

```bash
# 例: rackupを使用する場合
bundle exec rackup -p 3333 -E production
```

### 環境変数の管理

- `.env.example`をテンプレートとして使用
- 本番環境では環境変数管理サービス（Heroku Config Vars、AWS Parameter Storeなど）を使用することを推奨
- `.env`ファイルは`.gitignore`に含まれており、リポジトリにコミットされません

## セキュリティ

このアプリケーションには以下のセキュリティ対策が実装されています：

### セキュアなセッション管理

- `httponly: true` - JavaScriptからのセッションCookie読み取りを防止
- `secure: production?` - 本番環境でHTTPS接続のみでCookieを送信
- `same_site: :lax` - CSRF攻撃を緩和

### CSRF対策

- `Rack::Protection` - クロスサイトリクエストフォージェリ対策
- `Rack::Protection::AuthenticityToken` - トークンベース認証

### XSS対策

- ERBの自動エスケープ（`set :erb, escape_html: true`）- クロスサイトスクリプティング対策

### エラーハンドリング

- カスタムエラーページ（404, 500など）
- 適切なHTTPステータスコードの返却
- エラーログの記録

詳細は [IMPROVEMENT_DOCUMENTATION.md](IMPROVEMENT_DOCUMENTATION.md) を参照してください。

## ライセンス

このプロジェクトは [MIT License](LICENSE) の下でライセンスされています。

## コントリビューション

プロジェクトへの貢献を歓迎します！詳細は [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

## 参考資料

- [Sinatra公式ドキュメント](http://sinatrarb.com/)
- [ERB リファレンス](https://docs.ruby-lang.org/ja/latest/library/erb.html)
- [RSpec](https://rspec.info/)
- [Rack::Protection](https://github.com/sinatra/sinatra/tree/main/rack-protection)
