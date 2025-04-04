#!/bin/bash
# -*- coding: utf-8 -*-

set -euo pipefail

echo "pbfディレクトリにあるPBFファイルを選択してください："
select pbf in pbf/*.pbf; do
    if [ -n "$pbf" ]; then
        FILE_NAME=$(basename "$pbf")
        break
    else
        echo "有効な選択肢を入力してください。"
    fi
done


# GitHub APIを使ってJSONファイル一覧を取得
ENDPOINT="https://geolonia.github.io/tilemaker-processes"
# ユーザーにCONFIG_NAMEを入力してもらう
echo "使用するCONFIG_NAMEを入力してください（例: geolonia_v3）："
read -r CONFIG_NAME
time wget -O config/geolonia_v3.json "${ENDPOINT}/${CONFIG_NAME}.json"
time wget -O config/geolonia_v3.lua "${ENDPOINT}/${CONFIG_NAME}.lua"

chmod u+w mbtiles

# tilemakerの実行
time tilemaker \
  --input ${pbf} \
  --config config/${CONFIG_NAME}.json \
  --process config/${CONFIG_NAME}.lua \
  --output mbtiles/${pbf%.osm.pbf}.mbtiles
