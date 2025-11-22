#!/bin/bash
set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel)

for file in "$ROOT_DIR"/.github/ISSUES/[0-9]*.md; do
  # パターンに一致するファイルが無い場合はスキップ
  [[ -e "$file" ]] || continue

  # タイトルを抽出（最初の#行）
  title=$(grep -m 1 "^# " "$file" | sed 's/^# //')

  if [[ -z "$title" ]]; then
    echo "Warning: No title found in $file, skipping..." >&2
    continue
  fi

  # ラベルを抽出（手動で設定が必要）
  gh issue create --title "$title" --body-file "$file"
done
