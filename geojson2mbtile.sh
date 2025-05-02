#!/bin/bash

# geojson2mbtile: GeoJSONをMBTilesに変換するスクリプト

# 入力ディレクトリと出力ディレクトリを定義
GEOJSON_DIR="geojson"
MBTILES_DIR="mbtiles"

# tippecanoeコマンドがインストールされているか確認
if ! command -v tippecanoe &> /dev/null; then
  echo "tippecanoeがインストールされていません。以下のコマンドでインストールしてください:"
  echo "brew install tippecanoe" # macOSの場合
  echo "sudo apt install tippecanoe" # Ubuntuの場合
  exit 1
fi

# 入力ディレクトリの存在確認
if [ ! -d "$GEOJSON_DIR" ]; then
  echo "GeoJSONディレクトリが存在しません: $GEOJSON_DIR"
  exit 1
fi

# 出力ディレクトリの作成（存在しない場合）
if [ ! -d "$MBTILES_DIR" ]; then
  mkdir -p "$MBTILES_DIR"
  echo "MBTilesディレクトリを作成しました: $MBTILES_DIR"
fi

# GeoJSONディレクトリ内のすべてのGeoJSONファイルを処理
for GEOJSON_FILE in "$GEOJSON_DIR"/*.geojson; do
  # ファイルが存在しない場合はスキップ
  if [ ! -f "$GEOJSON_FILE" ]; then
    echo "GeoJSONファイルが見つかりません: $GEOJSON_FILE"
    continue
  fi

  # ファイル名から拡張子を除去してMBTilesファイル名を生成
  BASENAME=$(basename "$GEOJSON_FILE" .geojson)
  MBTILES_FILE="$MBTILES_DIR/$BASENAME.mbtiles"

  # GeoJSONをMBTilesに変換
  echo "変換中: $GEOJSON_FILE -> $MBTILES_FILE"
  tippecanoe -o "$MBTILES_FILE" "$GEOJSON_FILE" --force --maximum-zoom=14 --no-feature-limit --no-tile-size-limit

  if [ $? -eq 0 ]; then
    echo "変換成功: $MBTILES_FILE"
  else
    echo "変換失敗: $GEOJSON_FILE"
  fi
done

echo "すべての変換が完了しました。"
