import dotenv from "dotenv";
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { execSync } from "child_process";
import fs from "fs";

dotenv.config();

export const handler = async (event) => {
  console.log("starting the handler");
  const {
    DATABASE_HOST,
    DATABASE_NAME,
    DATABASE_USERNAME,
    DATABASE_PASSWORD,
    RDS_BACKUP_S3_BUCKET,
    ENVIRONMENT,
    REGION,
  } = process.env;
  
  const timestamp = new Date();
  const istOffset = 5.5 * 60 * 60 * 1000; // 5 hours and 30 minutes in milliseconds
  const timestampIST = new Date(timestamp.getTime() + istOffset);
  const formattedTimestamp = `${timestampIST.getFullYear()}-${String(
    timestampIST.getMonth() + 1
  ).padStart(2, "0")}-${String(timestampIST.getDate()).padStart(
    2,
    "0"
  )}-${String(timestampIST.getHours()).padStart(2, "0")}:${String(
    timestampIST.getMinutes()
  ).padStart(2, "0")}:${String(timestampIST.getSeconds()).padStart(2, "0")}`;
  
  
  
  try {
    console.log("taking pg_dump backup");
    
    const backupFilename = `backup_${DATABASE_NAME}_${formattedTimestamp}.sql`;
    const localBackupPath = `/tmp/${backupFilename}`;
    const pgDumpCommand = `pg_dump -h ${DATABASE_HOST} -U ${DATABASE_USERNAME} -d ${DATABASE_NAME} -f ${localBackupPath}`;

    const s3Client = new S3Client({ region: REGION });
    
    execSync(pgDumpCommand, {
      env: { ...process.env, PGPASSWORD: DATABASE_PASSWORD },
      stdio: "inherit",
    });

    const fileContent = fs.readFileSync(localBackupPath);

    console.log("sending to s3");
    await s3Client.send(
      new PutObjectCommand({
        Bucket: RDS_BACKUP_S3_BUCKET,
        Key: `${ENVIRONMENT}-rds/${backupFilename}`,
        Body: fileContent,
      })
    );
    console.log(
      `Backup successful! File uploaded to s3://${RDS_BACKUP_S3_BUCKET}/${backupFilename}`
    );

    return {
      statusCode: 200,
      body: `Backup successful! File uploaded to s3://${ENVIRONMENT}-rds/${backupFilename}`,
    };
  } catch (error) {
    console.error("Error during backup:", error);
    return {
      statusCode: 500,
      body: `Backup failed: ${error.message}`,
    };
  }
};
