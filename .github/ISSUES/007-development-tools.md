# 開発ツールの強化: 静的解析とCI/CDの導入

## ラベル
`tooling`, `enhancement`, `ci-cd`

## 優先度
🟡 中（開発効率と品質向上のため）

## 概要
コード品質を保つための静的解析ツールやCI/CDパイプラインが不足しています。

## 現状の問題
- RuboCopなどの静的解析ツールがない
- CI/CDパイプラインが未構築
- ロギング機能が未実装
- コード品質の自動チェックがない
- デプロイプロセスが不明確
- コーディング規約が統一されていない

## 改善策

### 1. RuboCopの導入

#### Gemfile
```ruby
group :development do
  gem 'rubocop', '~> 1.60', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end
```

#### .rubocop.yml
```yaml
AllCops:
  NewCops: enable
  TargetRubyVersion: 3.2
  Exclude:
    - 'vendor/**/*'
    - 'db/schema.rb'
    - 'bin/**/*'
    - 'node_modules/**/*'

Style/Documentation:
  Enabled: false

Style/FrozenStringLiteralComment:
  Enabled: true

Metrics/BlockLength:
  Exclude:
    - 'spec/**/*'
    - 'config/**/*'

Layout/LineLength:
  Max: 120
```

#### 実行方法
```bash
# チェック
bundle exec rubocop

# 自動修正
bundle exec rubocop -a

# 全自動修正（危険な変更も含む）
bundle exec rubocop -A
```

### 2. ロギング機能の実装

#### Gemfile
```ruby
gem 'logger'
```

#### config/logger.rb
```ruby
require 'logger'

class App < Sinatra::Base
  configure :development do
    set :logging, Logger::DEBUG
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    set :logger, logger
  end

  configure :production do
    logger = Logger.new('log/production.log', 'daily')
    logger.level = Logger::INFO
    set :logger, logger
  end

  configure :test do
    logger = Logger.new('log/test.log')
    logger.level = Logger::ERROR
    set :logger, logger
  end
end
```

#### 使用例
```ruby
get '/dashboard' do
  logger.info "Dashboard accessed"
  logger.debug "Generating list data"
  
  begin
    @list = DashboardService.generate_list
    slim :dashboard
  rescue => e
    logger.error "Error in dashboard: #{e.message}"
    logger.debug e.backtrace.join("\n")
    halt 500, "Internal Server Error"
  end
end
```

### 3. GitHub Actionsの設定

#### .github/workflows/ci.yml
```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        ruby-version: ['3.1', '3.2', '3.3']
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: ${{ matrix.ruby-version }}
        bundler-cache: true
    
    - name: Install dependencies
      run: bundle install
    
    - name: Run RuboCop
      run: bundle exec rubocop
    
    - name: Run tests
      run: bundle exec rspec
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage/coverage.xml

  security:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: '3.2'
        bundler-cache: true
    
    - name: Security audit
      run: |
        gem install bundler-audit
        bundle audit --update
```

### 4. pre-commitフックの設定

#### .git/hooks/pre-commit
```bash
#!/bin/sh

echo "Running pre-commit checks..."

# RuboCopチェック
echo "Running RuboCop..."
bundle exec rubocop --parallel

if [ $? -ne 0 ]; then
  echo "RuboCop failed. Please fix the issues before committing."
  exit 1
fi

# テスト実行（オプション）
# echo "Running tests..."
# bundle exec rspec

echo "All pre-commit checks passed!"
exit 0
```

実行権限を付与:
```bash
chmod +x .git/hooks/pre-commit
```

または、Lefthookの使用を推奨:

#### Gemfile
```ruby
group :development do
  gem 'lefthook', require: false
end
```

#### lefthook.yml
```yaml
pre-commit:
  parallel: true
  commands:
    rubocop:
      glob: "*.rb"
      run: bundle exec rubocop {staged_files}
    
    # テスト（オプション）
    # rspec:
    #   run: bundle exec rspec
```

インストール:
```bash
lefthook install
```

### 5. コードカバレッジの可視化

#### Gemfile
```ruby
group :test do
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false  # Codecov用
end
```

#### spec/spec_helper.rb
```ruby
require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  
  add_group 'Models', 'models'
  add_group 'Routes', 'routes'
  add_group 'Services', 'services'
  add_group 'Helpers', 'helpers'
  
  minimum_coverage 80
  minimum_coverage_by_file 70
  
  # Codecov用
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter
  ])
end
```

### 6. EditorConfigの設定

#### .editorconfig
```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.rb]
indent_style = space
indent_size = 2

[*.{yml,yaml}]
indent_style = space
indent_size = 2

[Gemfile]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

## 実装手順

### Phase 1: 静的解析ツール
- [ ] RuboCopのインストール
- [ ] .rubocop.ymlの設定
- [ ] 既存コードのRuboCop適用
- [ ] 自動修正の実行
- [ ] 残りの警告の手動修正

### Phase 2: ロギング
- [ ] ロガーの設定
- [ ] ログディレクトリの作成
- [ ] 各ルートにログ追加
- [ ] エラーハンドリングでのログ活用

### Phase 3: CI/CD
- [ ] GitHub Actionsワークフローの作成
- [ ] テストの自動実行設定
- [ ] RuboCopの自動実行設定
- [ ] セキュリティ監査の自動実行
- [ ] カバレッジレポートの設定

### Phase 4: Git Hooks
- [ ] Lefthookのインストール
- [ ] lefthook.ymlの設定
- [ ] pre-commitフックの有効化
- [ ] チーム内での共有

### Phase 5: ドキュメント
- [ ] .editorconfigの作成
- [ ] コーディング規約のドキュメント化
- [ ] CI/CDプロセスのドキュメント化
- [ ] README.mdの更新

## 追加で検討すべきツール

### コード品質
- **Reek**: コードの臭いを検出
- **Fasterer**: パフォーマンス改善提案
- **Brakeman**: セキュリティスキャン（Rails向けだが参考に）

### 依存関係管理
- **Dependabot**: 自動依存関係更新
- **bundler-audit**: セキュリティ脆弱性チェック

### その他
- **Better Errors**: 開発時のエラーページ改善
- **Pry-Rails**: デバッグツール強化

## チェックリスト
- [ ] RuboCopの導入と設定
- [ ] 既存コードのRuboCop対応
- [ ] ロギング機能の実装
- [ ] GitHub Actionsワークフローの作成
- [ ] pre-commitフックの設定
- [ ] SimpleCovの設定
- [ ] .editorconfigの作成
- [ ] Dependabotの設定
- [ ] bundler-auditの定期実行設定
- [ ] ドキュメントの更新

## 成功指標
- RuboCop違反: 0件
- テストカバレッジ: 80%以上
- CI/CD: すべてのPRで自動実行
- セキュリティ脆弱性: 0件

## 参考資料
- [RuboCop公式ドキュメント](https://docs.rubocop.org/)
- [GitHub Actions for Ruby](https://github.com/ruby/setup-ruby)
- [SimpleCov](https://github.com/simplecov-ruby/simplecov)
- [Lefthook](https://github.com/evilmartians/lefthook)

