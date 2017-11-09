# Mongo S3 Backup

This container runs a cron job which:

- dumps a mongo database using `mongodump`
- archives the dump and uploads it to Amazon S3

You can configure the execution of the above steps by setting the following
environment variables:

* `MONGO_HOST`
* `MONGO_PORT`
* `MONGO_DB`, optional, database name
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION`, optional
* `S3_BUCKET`
* `S3_PATH`, optional, path on S3 bucket
* `S3_STORAGE_CLASS`, optional, S3 Storage Class, ie. `STANDARD`, `REDUCED_REDUNDANCY`, `STANDARD_IA`, defaults to `STANDARD`
* `BACKUP_FILENAME_PREFIX`, optional, defaults to `mongo_backup`
* `BACKUP_FILENAME_DATE_FORMAT`, optional, defaults to `%Y%m%d`
* `CRON_SCHEDULE`, optional, defaults to `0 1 * * *`
