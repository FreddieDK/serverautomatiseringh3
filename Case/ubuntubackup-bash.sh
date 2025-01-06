#!/bin/bash

# Backup alt fra yderst rod
backup="/"

# Eksluder /mnt/ for eksterne mapped 
exclude_dirs=("--exclude=/mnt")

# Destination
dest="/mnt/backup/serverbackups"

# Opret arkiveret fil med tidspunkt/dato
tid=$(date +%d-%m-%Y)
hostname=$(hostname -s)
archive_fil="$hostname-$tid.tgz"

# Print besked til konsol
echo "Backing up $backup to $dest/$archive_fil"
date
echo

# Arkiver alle filer/mapper men eksluder nævnte drevs i variablen "exclude_dirs"
tar czf $dest/$archive_fil "${exclude_dirs[@]}" $backup

# Print status besked
echo
echo "Backup finished"
date

# Slet filer ældre end 14 dage via find kommado
find /mnt/backup/serverbackups -type f -mtime +14 -delete
