import { S3Client, CreateBucketCommand, HeadBucketCommand, ListBucketsCommand } from "@aws-sdk/client-s3";
import * as readline from "readline";


/* ******************** 
 * S3バケットの存在確認
 * ********************/ 
async function checkBucketExists(bucketName: string, s3Client: S3Client): Promise<boolean> {
  try {
    const command = new HeadBucketCommand({ Bucket: bucketName });
    console.log(command);
    await s3Client.send(command);
    return true; // バケットが存在する
  } catch (error: any) {
    if (error.name === "NotFound") {
      return false; // バケットが存在しない
    }
    throw error; // その他のエラー
  }
}

/* ******************** 
 * S3バケットの作成
 * ********************/ 
async function createBucket(bucketName: string, s3Client: S3Client) {
  try {
    const createCommand = new CreateBucketCommand({ Bucket: bucketName });
    await s3Client.send(createCommand);
    console.log(`バケット ${bucketName} を作成しました。`);

    const listCommand = new ListBucketsCommand({});
    const list = await s3Client.send(listCommand);
    console.log("現在のバケット一覧:", list.Buckets);

  } catch (error) {
    console.error(`バケットの作成に失敗しました:`, error);
  }
}

/* ******************** 
 * ユーザーに確認してバケットを作成
 * ********************/ 
export async function createBucketIfNotExists(bucketName: string, regionName: string) {
  try {
    const s3Client = new S3Client({ region: regionName });
    const exists = await checkBucketExists(bucketName, s3Client);
    
    if (exists) {
      console.log(`バケット ${bucketName} は既に存在します。`);
    } else {
      const userConfirmed = await askUserConfirmation(
        `バケット ${bucketName} は存在しません。新しく作成しますか？ (y/n): `
      );
      if (userConfirmed) {
        await createBucket(bucketName, s3Client);
      } else {
        console.log("バケットの作成をキャンセルしました。");
      }
    }
  } catch (error) {
    console.error(`バケットの確認または作成に失敗しました:`, error);
  }
}

/* ******************** 
 * ユーザー入力を受け取る関数
 * ********************/ 
function askUserConfirmation(question: string): Promise<boolean> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.toLowerCase() === "y" || answer.toLowerCase() === "yes");
    });
  });
}
