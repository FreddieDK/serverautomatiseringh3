#!/bin/bash

# Backupped filer
backup="/home /var/spool/mail /etc /root /boot /opt"

# Destination
dest="/mnt/backup/(Server Backup Mappe Navn)"

# Opret arkiveret fil med tidspunkt/dato
tid=$(date +%d-%m-%Y)
hostname=$(hostname -s)
archive_fil="$hostname-$fil.tgz"

# Print besked I console
echo "Backing op $backup til $dest/$archive_fil"
date
echo

# Arkiver/zip fil 
tar czf $dest/$archive_fil $backup

# Print status besked
echo
echo "Backup finished"
date

# slet filer ældre end 14 dage 
find /mnt/backup/(Server Backup Mappe Navn) -type f -mtime +14 -delete