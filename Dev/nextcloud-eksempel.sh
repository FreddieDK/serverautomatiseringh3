#!/bin/bash

# 1) sync live data fra storage-server til storage-backup
rsync -ah --delete root@10.0.15.12:/home/nextcloud/nextcloud/data/freddie/files /root/backup/nextcloud/live
sleep 10

# 2) zip live data
zip -rv /root/backup/nextcloud/backup.zip /root/backup/nextcloud/live
sleep 10

# 3) flyt zipped fil til diskstation med dato i navn
cp /root/backup/nextcloud/backup.zip /mnt/diskstation/nextcloud/backups/backup_$(date +%d-%m-%Y).zip
sleep 10
mv /root/backup/nextcloud/backup.zip /root/backup/nextcloud-archives/backup_$(date +%d-%m-%Y).zip

# 4) slet filer ældre end 14 dage - 3 dage lokalt
find /mnt/diskstation/nextcloud/backups -type f -mtime +14 -delete
find /root/backup/nextcloud-archives -type f -mtime +3 -delete
