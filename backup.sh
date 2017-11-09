#!/bin/bash

# Utility function
get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

OUT=$BACKUP_FILENAME_PREFIX-$(date +$BACKUP_FILENAME_DATE_FORMAT).tgz

# Script

echo "$(get_date) Mongo backup started"

echo "$(get_date) [Step 1/3] Running mongodump"
echo "$(get_date) mongodump --quiet -h $MONGO_HOST -p $MONGO_PORT $MONGO_DB_ARG"
mongodump --quiet -h $MONGO_HOST -p $MONGO_PORT $MONGO_DB_ARG

echo "$(get_date) [Step 2/3] Creating tar archive"
tar -zcvf $OUT dump/
rm -rf dump/

echo "$(get_date) [Step 3/3] Uploading archive to S3"
echo "$(get_date) aws s3api put-object --bucket $S3_BUCKET --key $S3_PATH$OUT --body $OUT --storage-class $S3_STORAGE_CLASS"
/usr/local/bin/aws s3api put-object --bucket $S3_BUCKET --key $S3_PATH$OUT --body $OUT --storage-class $S3_STORAGE_CLASS
rm $OUT

echo "$(get_date) Mongo backup completed successfully"
