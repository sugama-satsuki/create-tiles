#!/bin/bash

# シェルスクリプトからTypeScriptを実行する例

# S3バケット名を受け取る
read -p "S3バケット名を入力してください（必須）: " S3_BUCKET_NAME
if [ -z "$S3_BUCKET_NAME" ]; then
  echo "S3バケット名は必須です。"
  exit 1
fi

# リージョン名を受け取る（必須）
read -p "リージョン名を入力してください（必須）: " REGION_NAME
if [ -z "$REGION_NAME" ]; then
  echo "リージョン名は必須です。"
  exit 1
fi

# ディレクトリ名を受け取る（必須）
XYZ_DIR="xyz"
if [ ! -d "$XYZ_DIR" ]; then
  echo "ディレクトリ $XYZ_DIR が存在しません。"
  exit 1
fi

echo "以下のディレクトリから選択してください："
select DIRECTORY_NAME in $(find "$XYZ_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;); do
  if [ -n "$DIRECTORY_NAME" ]; then
    echo "選択されたディレクトリ: $DIRECTORY_NAME"
    break
  else
    echo "有効な選択肢を入力してください。"
  fi
done

# TypeScriptファイルのパス
TS_FILE="uploadToS3.ts"

# ts-nodeを使用してTypeScriptを実行
npx ts-node "$TS_FILE" "$S3_BUCKET_NAME" "$REGION_NAME" "$DIRECTORY_NAME"
