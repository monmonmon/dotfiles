#!/bin/bash

# file_backup.sh
# make a tarball of a target directory and rsync it to a remote server (if specified)
#
# crontab extample:
# 00 04 * * * /mbackup/mysql_backup.sh

# function
function log {
    echo "$(date): $*"
}

export PATH=/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
set -e

# read settings
cd $(dirname $0)
test -z "$1" && echo "Usage: $0 <conffile>" && exit 1
conffile=$1
test ! -r "$conffile" && echo "conffile not found: $conffile" && exit 1
source $conffile

# check parameters
test -n "$TARGET_DIRECTORY" || ( echo "parameter \$TARGET_DIRECTORY is required"; exit 2 )
test -d "$TARGET_DIRECTORY" || ( echo "\$TARGET_DIRECTORY is not a directory"; exit 2 )
test -n "$BACKUP_DIRECTORY" || ( echo "parameter \$BACKUP_DIRECTORY is required"; exit 2 )
test -d "$BACKUP_DIRECTORY" || ( echo "\$BACKUP_DIRECTORY is not a directory"; exit 2 )
if [ -n "$BACKUP_DURATION_DAYS" ]; then
    BACKUP_DURATION_DAYS=$(($BACKUP_DURATION_DAYS - 1))
else
    BACKUP_DURATION_DAYS=6
fi
if [ -z "$PREFIX" ]; then
    PREFIX=userfiles
fi

# determine backup file path
if [ "$COMPRESSION_TYPE" = "gz" ]; then
    # gzip compression
    backupfilepath=$BACKUP_DIRECTORY/$PREFIX-$(date +'%Y%m%d-%H%M').tar.gz
    tar_compress_option=z
elif [ "$COMPRESSION_TYPE" = "bz2" ]; then
    # gzip compression
    backupfilepath=$BACKUP_DIRECTORY/$PREFIX-$(date +'%Y%m%d-%H%M').tar.bz2
    tar_compress_option=j
else
    # no compression
    backupfilepath=$BACKUP_DIRECTORY/$PREFIX-$(date +'%Y%m%d-%H%M').tar
    tar_compress_option=
fi

# logging
if [ -n "$LOG_DIRECTORY" ]; then
    # 標準出力、標準エラー出力をファイルへ向ける
    logfile=$LOG_DIRECTORY/file_backup_$(date +"%Y-%m-%d-%H%M%S").log
    exec > $logfile 2>&1
fi

### BACKUP START ###
log "### running $0 on $(hostname) ###"

# make a backup on localhost
log 'creating tarball'
cd $(dirname $TARGET_DIRECTORY)
start_time=$(date +%s)
tar ${tar_compress_option}cf $backupfilepath $(basename $TARGET_DIRECTORY)
end_time=$(date +%s)
elapsed_time=$(($end_time - $start_time))
log "done ($elapsed_time sec)"

# delete old backups
log 'deleting old backups...'
find $BACKUP_DIRECTORY -maxdepth 1 -mtime +$BACKUP_DURATION_DAYS -a -name "${PREFIX}-*" -exec rm -rf {} \;
#find $BACKUP_DIRECTORY -maxdepth 1 -mmin +10 -a -name "${PREFIX}-*" -exec rm -rf {} \;
log 'done'

# copy the backup to a remote server
host "$REMOTE_SERVER" > /dev/null 2>&1
log $?
if [ -n "$REMOTE_SERVER" -a -n "$REMOTE_BACKUP_DIRECTORY" -a $? -eq 0 ]; then
    # delete old backups on the remove server
    log 'deleting old files on the remote server...'
    ssh -p 22 $REMOTE_SERVER "find $REMOTE_BACKUP_DIRECTORY -maxdepth 1 -mtime +$BACKUP_DURATION_DAYS -a -name '${PREFIX}-*' -exec rm -rf {} \;"
    log 'done'
    # rsync
    log "copying to a remote server..."
    rsync_cmd="rsync --bwlimit=8192 -avuzb $backupfilepath $REMOTE_SERVER:$REMOTE_BACKUP_DIRECTORY"
    log '$' $rsync_cmd
    start_time=$(date +%s)
    $rsync_cmd
    echo
    end_time=$(date +%s)
    elapsed_time=$(($end_time - $start_time))
    log "done ($elapsed_time sec)"
else
    log 'skip sending the backup to remote'
fi
