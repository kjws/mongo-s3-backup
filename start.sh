#!/bin/bash

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

CRON_ENVIRONMENT="
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?"env variable is required"}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?"env variable is required"}
MONGO_HOST=${MONGO_HOST:?"env variable is required"}
MONGO_PORT=${MONGO_PORT:?"env variable is required"}
S3_BUCKET=${S3_BUCKET:?"env variable is required"}
S3_PATH=${S3_PATH:-}
S3_STORAGE_CLASS=${S3_STORAGE_CLASS:-STANDARD}
BACKUP_FILENAME_DATE_FORMAT=${BACKUP_FILENAME_DATE_FORMAT:-%Y%m%d}
BACKUP_FILENAME_PREFIX=${BACKUP_FILENAME_PREFIX:-mongo_backup}
"

if [[ -n "$MONGO_DB" ]]; then
CRON_ENVIRONMENT="
$CRON_ENVIRONMENT
MONGO_DB_ARG=--db $MONGO_DB
"
fi

if [[ -n "$AWS_DEFAULT_REGION" ]]; then
CRON_ENVIRONMENT="
$CRON_ENVIRONMENT
AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
"
fi

LOGFIFO='/var/log/backup_script.log'
if [[ ! -e "$LOGFIFO" ]]; then
    touch "$LOGFIFO"
fi

CRON_COMMAND="/script/backup.sh > $LOGFIFO 2>&1"

echo
echo "Configuration"
echo
echo "CRON_SCHEDULE"
echo
echo "$CRON_SCHEDULE"
echo
echo "CRON_ENVIRONMENT"
echo "$CRON_ENVIRONMENT"

echo "$CRON_ENVIRONMENT$CRON_SCHEDULE $CRON_COMMAND" | crontab -

echo "crontab -l"
crontab -l

cron
tail -f $LOGFIFO
