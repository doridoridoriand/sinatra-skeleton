# バージョン管理の改善: Rubyバージョン明示とgem更新

## ラベル
`dependencies`, `enhancement`

## 優先度
🟡 中（保守性とセキュリティのため）

## 概要
Rubyのバージョンが明示されておらず、依存関係の管理が不十分です。

## 現状の問題
- `.ruby-version` ファイルが存在しない
- Gemfileにrubyバージョンの指定がない
- Rubyのバージョン要件が不明確
- gemのバージョンが古い可能性
- Gemfile.lockの定期的な更新がされていない可能性
- セキュリティ脆弱性のあるgemが含まれている可能性

## 改善策

### 1. .ruby-versionファイルの作成
```bash
# .ruby-version
3.2.2
```

**効果:**
- rbenvやrvmなどのバージョン管理ツールが自動的にRubyバージョンを切り替え
- チーム全体で統一されたRubyバージョンを使用

### 2. Gemfileにrubyバージョンを明示
```ruby
# Gemfile
source "https://rubygems.org"

ruby '3.2.2'  # または ruby '>= 3.0.0'

gem "sinatra", require: "sinatra/base"
# ...
```

### 3. 依存gemのバージョン確認と更新

#### 現在のバージョン確認
```bash
bundle outdated
```

#### セキュリティ監査
```bash
gem install bundler-audit
bundle audit check --update
```

#### 更新手順
```bash
# すべてのgemを最新に更新
bundle update

# または特定のgemのみ更新
bundle update sinatra
```

### 4. Gemfileのバージョン制約の追加
```ruby
# 推奨: 悲観的バージョン制約
gem "sinatra", "~> 3.0"      # 3.0.x の最新版を許可、4.0は不可
gem "slim", "~> 5.0"
gem "sass", "~> 3.7"

# 開発環境
group :development do
  gem "pry-byebug", "~> 3.10"
  gem "rspec", "~> 3.12"
  gem "guard", "~> 2.18"
  gem "guard-shotgun", "~> 0.4"
  gem "thin", "~> 1.8", require: false
end
```

### 5. Dependabotの設定
GitHub Dependabotを使用して、自動的にgemの更新PRを作成

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "bundler"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
```

### 6. CHANGELOG.mdの作成
バージョン変更履歴を管理

```markdown
# Changelog

## [Unreleased]

## [1.0.0] - 2024-01-01
### Added
- 初回リリース

### Changed
- Ruby 3.2.2に更新
- 依存gemを最新版に更新
```

## 実装手順

### ステップ1: 現状確認
```bash
# 現在のRubyバージョン
ruby -v

# 現在のgemバージョン
bundle list

# 古いgemの確認
bundle outdated

# セキュリティチェック
gem install bundler-audit
bundle audit
```

### ステップ2: Rubyバージョンの決定
- [ ] 使用するRubyバージョンを決定（推奨: 3.2.x または 3.3.x）
- [ ] チーム内で合意

### ステップ3: バージョンファイルの作成
- [ ] `.ruby-version` ファイル作成
- [ ] Gemfileにrubyバージョンを追加

### ステップ4: gem更新
- [ ] `bundle update` 実行
- [ ] セキュリティ脆弱性の確認
- [ ] テストの実行（Issue #2実装後）
- [ ] 動作確認

### ステップ5: 自動化設定
- [ ] Dependabot設定
- [ ] CI/CDでのbundle audit実行

### ステップ6: ドキュメント更新
- [ ] README.mdにRubyバージョン要件を明記
- [ ] CHANGELOG.md作成

## 推奨Rubyバージョン
- **Ruby 3.2.2以上** （2024年1月時点）
- Ruby 3.1.x もサポート範囲内

## 非推奨の書き方
```ruby
# Gemfile内の条件分岐は避ける
if RUBY_VERSION >= '2.0.0'
  gem "pry-byebug"
else
  gem "pry-debugger"  # Ruby 1.9は既にEOL
end
```

代わりに:
```ruby
# Rubyバージョンを明示し、古いバージョンはサポートしない
ruby '>= 3.0.0'
gem "pry-byebug"
```

## チェックリスト
- [ ] `.ruby-version` ファイルの作成
- [ ] Gemfileにrubyバージョン指定を追加
- [ ] 古い条件分岐の削除（pry-debugger関連）
- [ ] `bundle outdated` で確認
- [ ] `bundle audit` でセキュリティチェック
- [ ] gemのバージョン制約を追加
- [ ] `bundle update` 実行
- [ ] テストの実行
- [ ] Dependabotの設定
- [ ] CHANGELOG.mdの作成
- [ ] README.mdの更新

## 定期メンテナンス
- 月1回: `bundle outdated` でチェック
- 週1回: Dependabotの自動PR確認
- 随時: セキュリティアラートへの対応

## 参考資料
- [Bundler公式ドキュメント](https://bundler.io/)
- [RubyGems Security Best Practices](https://guides.rubygems.org/security/)
- [bundler-audit](https://github.com/rubysec/bundler-audit)

