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

# Python3のバージョン確認
if ! python3 --version &>/dev/null; then
    echo "Python3が見つかりません。Homebrewを使用してインストールします。"
    brew install python
fi

# pip3のバージョン確認
if ! pip3 --version &>/dev/null; then
    echo "pip3が見つかりません。Python3のインストールを確認してください。"
    exit 1
fi

pip3 install mbutil

mb-util --scheme=xyz "$mbtile" "xyz/$(basename "$mbtile" .mbtiles)"
