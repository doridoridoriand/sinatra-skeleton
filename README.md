# Install and Run

## Installation
```
$ bundle config set --local path '.bundle/gems'
$ bundle install --jobs 4
```

## Configuration
セキュリティのため、本番環境では環境変数を設定してください：

```bash
# .env.exampleを参考に.envファイルを作成
$ cp .env.example .env
# SESSION_SECRETを設定（必須）
$ export SESSION_SECRET=$(openssl rand -hex 64)
```

## Running the application
```
$ bundle exec guard -i
```

## Security Features
このアプリケーションには以下のセキュリティ対策が実装されています：
- セキュアなセッション管理（httponly, secure, same_site設定）
- CSRF対策（Rack::Protection）
- XSS対策（Slimテンプレートの自動エスケープ）

詳細は [IMPROVEMENT_DOCUMENTATION.md](IMPROVEMENT_DOCUMENTATION.md) を参照してください。
