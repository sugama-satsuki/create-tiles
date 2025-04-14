#!/bin/bash

# csv2geojson: CSVをGeoJSONに変換してgeojsonディレクトリに配置するスクリプト（ogr2ogrを使用）

# 入力ディレクトリと出力ディレクトリを定義
CSV_DIR="csv"
GEOJSON_DIR="geojson"

# ogr2ogrコマンドがインストールされているか確認
if ! command -v ogr2ogr &> /dev/null; then
  echo "ogr2ogrがインストールされていません。以下のコマンドでインストールしてください:"
  echo "brew install gdal" # macOSの場合
  echo "sudo apt install gdal-bin" # Ubuntuの場合
  exit 1
fi

# 入力ディレクトリの存在確認
if [ ! -d "$CSV_DIR" ]; then
  echo "CSVディレクトリが存在しません: $CSV_DIR"
  exit 1
fi

# 出力ディレクトリの作成（存在しない場合）
if [ ! -d "$GEOJSON_DIR" ]; then
  mkdir -p "$GEOJSON_DIR"
  echo "GeoJSONディレクトリを作成しました: $GEOJSON_DIR"
fi

# ユーザーから緯度と経度の列名を入力
read -p "CSVファイルの緯度列名を入力してください（例: latitude）: " LAT_COLUMN
if [ -z "$LAT_COLUMN" ]; then
  echo "緯度列名は必須です。"
  exit 1
fi

read -p "CSVファイルの経度列名を入力してください（例: longitude）: " LON_COLUMN
if [ -z "$LON_COLUMN" ]; then
  echo "経度列名は必須です。"
  exit 1
fi

# CSVディレクトリ内のすべてのCSVファイルを処理
for CSV_FILE in "$CSV_DIR"/*.csv; do
  # ファイルが存在しない場合はスキップ
  if [ ! -f "$CSV_FILE" ]; then
    echo "CSVファイルが見つかりません: $CSV_FILE"
    continue
  fi

  # ファイル名から拡張子を除去してGeoJSONファイル名を生成
  BASENAME=$(basename "$CSV_FILE" .csv)
  GEOJSON_FILE="$GEOJSON_DIR/$BASENAME.geojson"

  # CSVをGeoJSONに変換
  echo "変換中: $CSV_FILE -> $GEOJSON_FILE"
  ogr2ogr -f "GeoJSON" "$GEOJSON_FILE" "$CSV_FILE" -oo X_POSSIBLE_NAMES="$LON_COLUMN" -oo Y_POSSIBLE_NAMES="$LAT_COLUMN"

  if [ $? -eq 0 ]; then
    echo "変換成功: $GEOJSON_FILE"
  else
    echo "変換失敗: $CSV_FILE"
  fi
done

echo "すべての変換が完了しました。"
