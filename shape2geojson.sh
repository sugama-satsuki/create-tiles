#!/bin/bash

# filepath: /Users/higuchi/Documents/dev/shell/create-tiles/shape2mbtiles.sh

# 入力ディレクトリと出力ファイルの設定
SHAPE_DIR="./shape"
MBTILES_DIR="./mbtiles"
OUTPUT_FILE="$MBTILES_DIR/output.mbtiles"

# Tippecanoeの引数を初期化
TIPPECANOE_ARGS=""

# 出力ディレクトリの作成（存在しない場合）
if [ ! -d "$MBTILES_DIR" ]; then
  mkdir -p "$MBTILES_DIR"
  echo "MBTilesディレクトリを作成しました: $MBTILES_DIR"
fi

# シェープファイルをGeoJSONに変換してレイヤーを構築
for SHAPE_FILE in "$SHAPE_DIR"/*.shp; do
  # ファイルが存在しない場合はスキップ
  if [ ! -f "$SHAPE_FILE" ]; then
    echo "シェープファイルが見つかりません: $SHAPE_FILE"
    continue
  fi

  # ファイル名から拡張子を除去してレイヤー名を生成
  BASENAME=$(basename "$SHAPE_FILE" .shp)
  GEOJSON_FILE="$SHAPE_DIR/$BASENAME.geojson"

  # シェープファイルをGeoJSONに変換
  echo "変換中: $SHAPE_FILE -> $GEOJSON_FILE"
  ogr2ogr -f GeoJSON "$GEOJSON_FILE" "$SHAPE_FILE"

  if [ $? -eq 0 ]; then
    echo "変換成功: $GEOJSON_FILE"
    TIPPECANOE_ARGS+=" -L ${BASENAME}:$GEOJSON_FILE"
  else
    echo "変換失敗: $SHAPE_FILE"
    continue
  fi
done
