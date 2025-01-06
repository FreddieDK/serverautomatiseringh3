#!/bin/bash

# Backupped filer
backup="/home /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup/(Server Backup Mappe Navn)"

# Create archive filename with timestamp.
tid=$(date +"%Y%m%d-%H%M")
hostname=$(hostname -s)
archive_fil="$hostname-$fil.tgz"

# Print start status message.
echo "Backing up $backup to $dest/$archive_fil"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_fil $backup

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
