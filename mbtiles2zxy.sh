#!/bin/bash
# -*- coding: utf-8 -*-

set -euo pipefail

echo "mbtilesディレクトリにあるMBTilesファイルを選択してください："
select mbtile in mbtiles/*.mbtiles; do
    if [ -n "$mbtile" ]; then
        TILE_NAME=$(basename "$mbtile" .mbtiles)
        break
    else
        echo "有効な選択肢を入力してください。"
    fi
done

mb-util --scheme=zxy "$mbtile" "zxy/$mbtile"
