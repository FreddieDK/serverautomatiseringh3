#!/bin/bash

# Backupped filer
backup="/home /var/spool/mail /etc /root /boot /opt"

# Destination
dest="/mnt/backup/serverbackups"

# Opret arkiveret fil med tidspunkt/dato
tid=$(date +%Y-%m-%d-%H-%M)
hostname=$(hostname -s)
archive_fil="$hostname-$tid.tgz"




# Print besked I console
echo "Backup op af $backup til $dest/$archive_fil"
date
echo

# Arkiver/zip fil
tar czf $dest/$archive_fil $backup

# Print status besked
echo
echo "Backup finished"
date

# slet filer ældre end 14 dage
find /mnt/backup/serverbackups -type f -mtime +14 -delete
