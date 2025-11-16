# テストの実装: RSpecによる包括的なテストカバレッジ

## ラベル
`testing`, `enhancement`

## 優先度
🔴 高（品質保証のため）

## 概要
RSpecがGemfileに含まれていますが、実際のテストコードが一つも存在しません。

## 現状の問題
- specディレクトリが存在しない
- テストファイル（*_spec.rb）が存在しない
- テストカバレッジが0%
- リグレッション検出ができない
- CI/CDでの自動テストが未構築

## 改善策

### 1. specディレクトリの作成と構造化
```
spec/
  ├── spec_helper.rb
  ├── support/
  ├── features/      # E2Eテスト
  ├── requests/      # リクエストテスト
  └── models/        # モデルテスト（将来用）
```

### 2. spec_helper.rbの設定
```ruby
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../../webapp', __FILE__)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  
  def app
    WebApp
  end
end
```

### 3. ルーティングのテスト作成

#### `GET /` のテスト
```ruby
# spec/requests/home_spec.rb
RSpec.describe 'GET /' do
  it 'returns 200 OK' do
    get '/'
    expect(last_response).to be_ok
  end
  
  it 'displays welcome title' do
    get '/'
    expect(last_response.body).to include('Welcome')
  end
end
```

#### `GET /dashboard` のテスト
```ruby
# spec/requests/dashboard_spec.rb
RSpec.describe 'GET /dashboard' do
  it 'returns 200 OK' do
    get '/dashboard'
    expect(last_response).to be_ok
  end
  
  it 'displays dashboard title' do
    get '/dashboard'
    expect(last_response.body).to include('Dashboard')
  end
end
```

#### `GET /css/application.css` のテスト
```ruby
# spec/requests/assets_spec.rb
RSpec.describe 'GET /css/application.css' do
  it 'returns CSS content' do
    get '/css/application.css'
    expect(last_response).to be_ok
    expect(last_response.content_type).to include('text/css')
  end
end
```

### 4. カバレッジツールの導入
```ruby
# Gemfile
group :test do
  gem 'simplecov', require: false
end

# spec/spec_helper.rb
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
end
```

### 5. CI/CDでのテスト自動実行
GitHub Actionsの設定例（.github/workflows/test.yml）

## チェックリスト
- [ ] specディレクトリの作成
- [ ] spec_helper.rbの設定
- [ ] ルーティングテストの実装
- [ ] SimpleCovの導入
- [ ] カバレッジ目標の設定（80%以上）
- [ ] CI/CD設定
- [ ] README.mdにテスト実行方法を追記

## 目標
- テストカバレッジ: 80%以上
- 全てのエンドポイントにテストを作成
- CI/CDでの自動テスト実行

