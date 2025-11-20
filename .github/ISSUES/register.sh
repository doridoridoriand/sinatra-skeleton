#!/bin/bash
ROOT_DIR=$(git rev-parse --show-toplevel)
for file in $ROOT_DIR/.github/ISSUES/[0-9]*.md; do
  # タイトルを抽出（最初の#行）
  title=$(grep -m 1 "^# " "$file" | sed 's/^# //')
  
  # ラベルを抽出（手動で設定が必要）
  gh issue create --title "$title" --body-file "$file"
done