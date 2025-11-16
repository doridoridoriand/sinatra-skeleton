# アーキテクチャ改善: MVC層の明確化とモデル層の追加

## ラベル
`architecture`, `enhancement`, `refactoring`

## 優先度
🟡 中（将来的な拡張性のため）

## 概要
現在の構造ではMVCパターンが明確に実装されておらず、すべてのロジックがwebapp.rbに集中しています。

## 現状の問題
- モデル層が存在しない
- ビジネスロジックとプレゼンテーション層が混在
- webapp.rb内にすべてのルーティングが集中
- 機能拡張が困難
- コードの再利用性が低い
- テストが書きにくい

## 現在の構造
```
.
├── config.ru
├── webapp.rb        # すべてのロジックがここに
├── views/
│   ├── layout.slim
│   ├── index.slim
│   └── dashboard.slim
└── Gemfile
```

## 提案する構造

### オプション1: シンプルな構造（小〜中規模向け）
```
.
├── config.ru
├── app.rb                 # アプリケーション設定
├── config/
│   ├── database.rb       # DB設定（必要な場合）
│   └── environments.rb   # 環境別設定
├── models/               # モデル層
│   └── user.rb
├── helpers/              # ヘルパーメソッド
│   └── application_helper.rb
├── routes/               # ルーティング（機能別）
│   ├── main.rb
│   └── dashboard.rb
├── services/             # ビジネスロジック
│   └── user_service.rb
├── views/
│   ├── layout.slim
│   ├── index.slim
│   └── dashboard.slim
└── spec/
    ├── models/
    ├── routes/
    └── services/
```

### オプション2: Modular Application（大規模向け）
```
.
├── config.ru
├── config/
│   ├── boot.rb
│   ├── database.rb
│   └── environments/
│       ├── development.rb
│       ├── production.rb
│       └── test.rb
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── home_controller.rb
│   │   └── dashboard_controller.rb
│   ├── models/
│   │   └── user.rb
│   ├── helpers/
│   │   └── application_helper.rb
│   ├── services/
│   │   └── user_service.rb
│   └── views/
│       ├── layouts/
│       ├── home/
│       └── dashboard/
├── lib/
│   └── core_ext/
├── public/
│   ├── css/
│   ├── js/
│   └── images/
└── spec/
```

## 実装例

### 1. ルーティングの分割

#### app.rb（メインアプリケーション）
```ruby
class App < Sinatra::Base
  register Sinatra::Twitter::Bootstrap::Assets
  
  configure do
    set :views, File.join(settings.root, 'views')
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET')
  end
  
  configure :development do
    register Sinatra::Reloader
  end
  
  # ヘルパーの読み込み
  helpers ApplicationHelper
  
  # ルーティングの読み込み
  use MainRoutes
  use DashboardRoutes
end
```

#### routes/main.rb
```ruby
class MainRoutes < Sinatra::Base
  get "/" do
    @title = "Welcome"
    slim :index, layout: :layout_1col
  end
  
  get "/css/application.css" do
    sass :application
  end
end
```

#### routes/dashboard.rb
```ruby
class DashboardRoutes < Sinatra::Base
  get "/dashboard" do
    @title = "Dashboard"
    @list = DashboardService.generate_list
    slim :dashboard
  end
end
```

### 2. サービス層の追加

#### services/dashboard_service.rb
```ruby
class DashboardService
  def self.generate_list
    (1..80).map do |i|
      {
        id: i,
        name: Forgery(:name).full_name,
        email: Forgery(:internet).email_address,
        joined: Forgery(:date).date.to_time
      }
    end
  end
end
```

### 3. モデル層の追加（データベース使用時）

#### Gemfile
```ruby
gem 'sequel'      # または 'activerecord'
gem 'sqlite3'     # または使用するDB
```

#### config/database.rb
```ruby
require 'sequel'

DB = Sequel.connect(
  adapter: 'sqlite',
  database: "db/#{ENV['RACK_ENV']}.sqlite3"
)
```

#### models/user.rb
```ruby
class User < Sequel::Model
  plugin :validation_helpers
  
  def validate
    super
    validates_presence [:name, :email]
    validates_unique :email
  end
end
```

### 4. 環境別設定の分離

#### config/environments.rb
```ruby
configure :development do
  set :show_exceptions, true
  set :dump_errors, true
end

configure :production do
  set :show_exceptions, false
  set :dump_errors, false
  set :raise_errors, true
end

configure :test do
  set :show_exceptions, true
  set :dump_errors, true
end
```

## 移行手順

### Phase 1: ディレクトリ構造の準備
- [ ] 必要なディレクトリの作成
- [ ] webapp.rbのバックアップ

### Phase 2: ヘルパーの分離
- [ ] helpers/ディレクトリ作成
- [ ] 共通メソッドをヘルパーに移動

### Phase 3: ルーティングの分離
- [ ] routes/ディレクトリ作成
- [ ] 機能ごとにルーティングファイルを作成
- [ ] webapp.rbから段階的に移行

### Phase 4: サービス層の導入
- [ ] services/ディレクトリ作成
- [ ] ビジネスロジックをサービスに移動
- [ ] ルーティングからサービスを呼び出し

### Phase 5: 設定の分離
- [ ] config/ディレクトリ作成
- [ ] 環境別設定ファイルの作成
- [ ] config.ruの更新

### Phase 6: モデル層の追加（必要な場合）
- [ ] ORMの選定（Sequel/ActiveRecord）
- [ ] models/ディレクトリ作成
- [ ] データベース設定
- [ ] マイグレーションファイルの作成

### Phase 7: テストの更新
- [ ] 新しい構造に合わせてテストを更新
- [ ] 各層のテストを追加

## メリット
1. **保守性の向上**
   - 責務が明確化
   - コードの可読性向上

2. **テストのしやすさ**
   - 各層を独立してテスト可能
   - モックやスタブが使いやすい

3. **拡張性**
   - 新機能の追加が容易
   - 既存コードへの影響を最小化

4. **再利用性**
   - サービス層のロジックを複数の場所で使用可能
   - ヘルパーメソッドの共有

## 注意点
- 小規模プロジェクトでは過度な分割は避ける
- YAGNIの原則（You Aren't Gonna Need It）を守る
- 必要に応じて段階的にリファクタリング

## チェックリスト
- [ ] ディレクトリ構造の決定（オプション1 or 2）
- [ ] ディレクトリの作成
- [ ] ヘルパーの分離
- [ ] ルーティングの分離
- [ ] サービス層の導入
- [ ] 設定ファイルの分離
- [ ] モデル層の追加（必要な場合）
- [ ] テストの更新
- [ ] ドキュメントの更新
- [ ] 動作確認

## 参考資料
- [Sinatra Modular vs Classic](http://sinatrarb.com/intro.html#Sinatra::Base%20-%20Middleware,%20Libraries,%20and%20Modular%20Apps)
- [Sinatra Best Practices](https://github.com/sinatra/sinatra/blob/master/PATTERNS.md)
- [Sequel ORM](https://sequel.jeremyevans.net/)
- [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html)

