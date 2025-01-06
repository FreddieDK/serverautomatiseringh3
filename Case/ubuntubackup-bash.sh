#!/bin/bash

# Backup source: Everything from root directory except excluded folders
backup="/"

# Exclude directories (e.g., /mnt, /proc, /sys, /dev, etc.)
exclude_dirs=("--exclude=/mnt")

# Destination
dest="/mnt/backup/serverbackups"

# Create archive filename with date/time
tid=$(date +%d-%m-%Y)
hostname=$(hostname -s)
archive_fil="$hostname-$tid.tgz"

# Print message to console
echo "Backing up $backup to $dest/$archive_fil"
date
echo

# Archive/zip files while excluding specified directories
tar czf $dest/$archive_fil "${exclude_dirs[@]}" $backup

# Print status message
echo
echo "Backup finished"
date

# Delete files older than 14 days
find /mnt/backup/serverbackups -type f -mtime +14 -delete
