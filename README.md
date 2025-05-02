# create-tiles

pbf to xyz
csv to mbtiles

## 変換系
### pbfをxyz形式に変換する
1. pbfディレクトリに変換したいファイルを配置。
2. 以下を実行すると、mbtilesディレクトリにmbtilesが生成されます。
```
npm run pbf2mbtiles
```
3. 以下を実行すると、mbtilesディレクトリにあるタイルをxyz形式のタイルが生成され、xyz/mbtilesのファイル名/直下に配置されます。
```
npm run mbtiles2xyz
```

### csvをmbtilesに変換する
1. csvディレクトリに変換したいファイルを配置。
2. 以下を実行すると、geojsonディレクトリにgeojsonが生成されます。
```
npm run csv2geojson
```
3. 以下を実行すると、mbtilesディレクトリにmbtilesが生成されます。
※ 注意：geojsonディレクトリ内にあるgeojsonファイルが全て結合されてmbtilesになります。
```
npm run geojson2mbtiles
```

## アップロード系
1. 以下でxyzタイルをS3にアップロードできる。
```
npm run upload:xyz
```
