## サンプルのため、ファイル名を変更して使う
# 座標系を確認
ogrinfo -al -so geojson/景観計画区域.geojson
# 座標系を変更
ogr2ogr -f GeoJSON -t_srs EPSG:4326 景観計画区域.geojson geojson/景観計画区域.geojson
