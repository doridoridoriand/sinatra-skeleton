# 非推奨gemの更新: sinatra-twitter-bootstrapの置き換え

## ラベル
`dependencies`, `enhancement`, `security`

## 優先度
🟠 中〜高（セキュリティリスクのため）

## 概要
`sinatra-twitter-bootstrap` gemは非推奨となっており、更新が停止している可能性があります。

## 現状の問題
- `sinatra-twitter-bootstrap` の最終更新が2013年頃
- セキュリティ脆弱性のリスク
- 最新のBootstrapバージョン（v5.x）が使用できない
- 古いBootstrap 3.xに依存している可能性

## 影響範囲の調査

### 現在の使用箇所
```ruby
# Gemfile
gem "sinatra-twitter-bootstrap"

# config.ru
require "sinatra/twitter-bootstrap"

# webapp.rb
register Sinatra::Twitter::Bootstrap::Assets
```

## 改善策

### オプション1: CDN経由でBootstrapを読み込む（推奨）
最もシンプルで保守性が高い方法

```slim
/ views/layout.slim
doctype html
html
  head
    link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
    script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
```

**メリット:**
- gemの依存関係が減る
- 最新のBootstrap 5が使える
- CDNのキャッシュ効果
- メンテナンスが容易

**デメリット:**
- オフライン開発ができない
- CDNに依存

### オプション2: Sprocketsを使用
より高度なアセット管理が必要な場合

```ruby
# Gemfile
gem 'sprockets'
gem 'bootstrap', '~> 5.3.0'

# webapp.rb
require 'sprockets'
set :sprockets, Sprockets::Environment.new
settings.sprockets.append_path 'assets/javascripts'
settings.sprockets.append_path 'assets/stylesheets'
```

### オプション3: Webpackerの導入
最も現代的だが、複雑さが増す

## 移行手順

### ステップ1: 現状の把握
- [ ] 現在のBootstrapバージョンを確認
- [ ] 使用しているBootstrapコンポーネントをリスト化
- [ ] カスタムスタイルの確認

### ステップ2: Bootstrap 5への移行準備
- [ ] Bootstrap 5の変更点を確認
- [ ] 互換性のない機能のリストアップ
- [ ] 移行ガイドの確認

### ステップ3: 実装
- [ ] `sinatra-twitter-bootstrap` をGemfileから削除
- [ ] 新しいBootstrap読み込み方法を実装
- [ ] レイアウトファイルの更新

### ステップ4: テストと検証
- [ ] すべてのページの表示確認
- [ ] レスポンシブデザインの確認
- [ ] ブラウザ互換性の確認

### ステップ5: クリーンアップ
- [ ] 不要なコードの削除
- [ ] ドキュメントの更新

## Bootstrap 3 → 5 の主な変更点
- jQuery依存の削除
- グリッドシステムの改善
- ユーティリティクラスの刷新
- `.ml-*` → `.ms-*` (margin-left → margin-start)
- `.mr-*` → `.me-*` (margin-right → margin-end)
- フォームの構造変更

## チェックリスト
- [ ] 依存関係の調査完了
- [ ] 移行方法の決定（オプション1/2/3）
- [ ] `sinatra-twitter-bootstrap` の削除
- [ ] 新しいBootstrap統合の実装
- [ ] ビューファイルの更新
- [ ] スタイルの調整
- [ ] 全ページの動作確認
- [ ] テストの更新
- [ ] ドキュメントの更新

## 参考資料
- [Bootstrap 5 公式ドキュメント](https://getbootstrap.com/)
- [Bootstrap 4 → 5 移行ガイド](https://getbootstrap.com/docs/5.0/migration/)
- [sinatra-twitter-bootstrap リポジトリ](https://github.com/yassermohammad/sinatra-twitter-bootstrap)

## 注意事項
- 既存のデザインが崩れる可能性があるため、慎重に移行する
- 移行前にスクリーンショットを取っておく
- 段階的にページごとに移行することも検討

