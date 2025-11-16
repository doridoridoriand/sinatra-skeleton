# Issues管理

このディレクトリには、Sinatra Skeletonプロジェクトの改善項目がIssueとして管理されています。

## 概要

IMPROVEMENT_DOCUMENTATION.mdに基づいて、以下の8つの主要な改善項目が特定されました。各Issueは優先度順に番号が付けられています。

## Issue一覧

### 🔴 高優先度

| # | タイトル | ラベル | 説明 |
|---|---------|--------|------|
| 001 | [セキュリティ強化](./001-security-enhancement.md) | `security`, `enhancement` | セッション管理、CSRF/XSS対策の実装 |
| 002 | [テストの実装](./002-testing-implementation.md) | `testing`, `enhancement` | RSpecによる包括的なテストカバレッジ |

### 🟠 中〜高優先度

| # | タイトル | ラベル | 説明 |
|---|---------|--------|------|
| 004 | [非推奨gemの更新](./004-deprecated-gems-update.md) | `dependencies`, `enhancement`, `security` | sinatra-twitter-bootstrapの置き換え |

### 🟡 中優先度

| # | タイトル | ラベル | 説明 |
|---|---------|--------|------|
| 003 | [ドキュメントの充実](./003-documentation-improvement.md) | `documentation`, `enhancement` | README.mdとプロジェクト構成の説明 |
| 005 | [バージョン管理の改善](./005-version-management.md) | `dependencies`, `enhancement` | Rubyバージョン明示とgem更新 |
| 006 | [アーキテクチャ改善](./006-architecture-improvement.md) | `architecture`, `enhancement`, `refactoring` | MVC層の明確化とモデル層の追加 |
| 007 | [開発ツールの強化](./007-development-tools.md) | `tooling`, `enhancement`, `ci-cd` | 静的解析とCI/CDの導入 |
| 008 | [エラーハンドリング](./008-error-handling.md) | `enhancement`, `user-experience` | 適切なエラーハンドリングの実装 |

## 優先度の説明

- 🔴 **高**: セキュリティや品質に直結する重要な項目。最優先で対応すべき。
- 🟠 **中〜高**: セキュリティリスクがあるが、影響範囲が限定的な項目。
- 🟡 **中**: 保守性や開発効率の向上に寄与する項目。

## 推奨実装順序

1. **Phase 1: 基盤整備**
   - #002 テストの実装（テストフレームワークの構築）
   - #005 バージョン管理の改善（環境の統一）

2. **Phase 2: セキュリティ**
   - #001 セキュリティ強化（最優先のセキュリティ対策）

3. **Phase 3: 依存関係の整理**
   - #004 非推奨gemの更新（古い技術の刷新）

4. **Phase 4: 品質向上**
   - #007 開発ツールの強化（CI/CD、静的解析）
   - #008 エラーハンドリング（ユーザー体験の向上）

5. **Phase 5: リファクタリング**
   - #006 アーキテクチャ改善（拡張性の向上）

6. **Phase 6: ドキュメント**
   - #003 ドキュメントの充実（最終的な整備）

## GitHub Issueへの登録

このディレクトリのファイルは、GitHub Issueテンプレートとして使用できます。

### 手動登録
各ファイルの内容をコピーして、GitHubのIssueとして手動で作成してください。

### GitHub CLI使用
```bash
# 例: Issue #001を登録
gh issue create --title "セキュリティ強化: セッション管理とCSRF/XSS対策の実装" \
  --body-file .github/ISSUES/001-security-enhancement.md \
  --label "security,enhancement"
```

### 一括登録スクリプト（オプション）
```bash
#!/bin/bash
for file in .github/ISSUES/[0-9]*.md; do
  # タイトルを抽出（最初の#行）
  title=$(grep -m 1 "^# " "$file" | sed 's/^# //')
  
  # ラベルを抽出（手動で設定が必要）
  gh issue create --title "$title" --body-file "$file"
done
```

## 進捗管理

各Issueには「チェックリスト」セクションがあります。作業を進める際は、完了した項目にチェックを入れて進捗を管理してください。

```markdown
- [x] 完了した項目
- [ ] 未完了の項目
```

## 関連ドキュメント

- [IMPROVEMENT_DOCUMENTATION.md](../../IMPROVEMENT_DOCUMENTATION.md) - 改善点の詳細分析
- [README.md](../../README.md) - プロジェクト概要（要更新）

## 更新履歴

- 2024-01-01: 初回作成、8つのIssueを作成

