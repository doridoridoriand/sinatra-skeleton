# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 包括的なREADME.mdの作成
- CONTRIBUTING.mdの追加（コントリビューションガイドライン）
- LICENSEファイルの追加（MIT License）
- CHANGELOG.mdの追加

### Changed
- README.mdを大幅に拡充（プロジェクト概要、技術スタック、セットアップ手順など）

### Security
- セキュアなセッション管理の実装
  - httponly、secure、same_site属性の設定
  - SESSION_SECRET環境変数による安全な管理
- CSRF対策の実装
  - Rack::Protectionの有効化
  - Rack::Protection::AuthenticityTokenの実装
- XSS対策の実装
  - Slimテンプレートのデフォルトエスケープ

## [0.1.0] - 2025-11-16

### Added
- Sinatraベースのスケルトンプロジェクトの初期実装
- Slimテンプレートエンジンの統合
- Sassプリプロセッサの統合
- Bootstrap UIフレームワークの統合
- Guard + LiveReload による自動リロード機能
- RSpecテストフレームワークの統合
- カスタムエラーハンドリング（404, 500など）
- エラークラスの定義（ValidationError, NotFoundError, UnauthorizedError, ForbiddenError）
- ダッシュボードページのサンプル実装
- .env.exampleの作成（環境変数のサンプル）
- IMPROVEMENT_DOCUMENTATION.mdの追加（改善点のドキュメント）

### Development
- Pry-byebugデバッガーの統合
- Guardfileの設定（ファイル監視と自動リロード）
- Thinサーバーの使用

[Unreleased]: https://github.com/doridoridoriand/sinatra-skeleton/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/doridoridoriand/sinatra-skeleton/releases/tag/v0.1.0
