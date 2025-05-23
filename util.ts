import * as fs from "fs";
import * as path from "path";
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { fromIni } from "@aws-sdk/credential-providers";


// S3クライアントの作成
let s3Client = new S3Client({ 
    region: "ap-northeast-1",
    credentials: fromIni({ profile: "781917250095_AdministratorAccess" })
});

async function refreshCredentials() {
    s3Client = new S3Client({
        region: "ap-northeast-1",
        credentials: fromIni({ profile: "781917250095_AdministratorAccess" }),
    });
    console.log("Credentials refreshed");
}

// 定期的に認証情報を更新（例: 1時間ごと）
setInterval(refreshCredentials, 60 * 60 * 1000);

/**
 * 指定されたローカルディレクトリをS3にアップロードする関数
 * @param localDir ローカルディレクトリのパス
 * @param bucket S3バケット名
 * @param s3Prefix S3上のプレフィックス
 */
export async function uploadDirectoryToS3(localDir: string, bucket: string, s3Prefix: string): Promise<void> {
    const files = fs.readdirSync(localDir);

    for (const file of files) {
        const fullPath = path.join(localDir, file);
        const s3Path = path.join(s3Prefix, file).replace(/\\/g, "/"); // Windows対応

        console.log(`Processing ${fullPath}...`, s3Path);

        if (fs.statSync(fullPath).isDirectory()) {
            // サブディレクトリの場合は再帰的にアップロード
            await uploadDirectoryToS3(fullPath, bucket, s3Path);
        } else {
            // ファイルをS3にアップロード
            try {
                console.log(`Uploading ${fullPath} to s3://${bucket}/${s3Path}...`);
                const fileContent = fs.readFileSync(fullPath);
                const command = new PutObjectCommand({
                    Bucket: bucket,
                    Key: s3Path,
                    Body: fileContent,
                });
                await s3Client.send(command);
                console.log(`Uploaded ${fullPath} to s3://${bucket}/${s3Path}`);
            } catch (error) {
                console.error(`Failed to upload ${fullPath}:`, error);
            }
        }
    }
}
