import * as fs from "fs";
import path from "path";
import { createBucketIfNotExists } from "./createS3Backet";
import { uploadDirectoryToS3 } from "./util";


// アップロード元ディレクトリ
const XYZ_DIR = "xyz/";

// コマンドライン引数から変数を取得
const bucketName = process.argv[2];
const regionName = process.argv[3];
const directoryName = process.argv[4];

if (!bucketName || !regionName || !directoryName) {
  console.error("S3バケット名、リージョン名、ディレクトリ名を指定してください。");
  process.exit(1);
}

/**
 * メイン処理
 * @param bucketName S3バケット名
 */
async function main(bucketName: string, regionName: string, directlyName: string) {
  console.log(`S3バケット ${bucketName} にアップロードを開始します...`);
  console.log(`アップロード元ディレクトリ: ${XYZ_DIR}/${directlyName}`);

  // バケットが存在しない場合は作成
  await createBucketIfNotExists(bucketName, regionName);

  // アップロード元ディレクトリが存在するか確認
  if (!fs.existsSync(`${XYZ_DIR}/${directlyName}`)) {
    console.error(`アップロード元ディレクトリ ${XYZ_DIR}/${directlyName} が存在しません。`);
    return;
  }

  // サブディレクトリをループ処理
  const subDirs = fs.readdirSync(`${XYZ_DIR}/${directlyName}`).filter((subDir) =>
    fs.statSync(path.join(`${XYZ_DIR}/${directlyName}`, subDir)).isDirectory()
  );

  console.log(`ディレクトリ ${subDirs} をアップロード中...`);

  for (const subDir of subDirs) {
    const fullPath = path.join(`${XYZ_DIR}/${directlyName}`, subDir);
    await uploadDirectoryToS3(fullPath, bucketName, subDir);
  }

  console.log("すべてのディレクトリのアップロードが完了しました。");
}

main(bucketName, regionName, directoryName).catch((error) => {
  console.error("エラーが発生しました:", error);
});
