#!/bin/bash

<<<<<<< Updated upstream
# Backup alt fra yderst rod
backup="/"

# Eksluder /mnt/ for eksterne mapped 
exclude_=("--exclude=/mnt")

=======
# Backupped filer
#backup="/home /var/spool/mail /etc /root /boot /opt"
backup="/"
>>>>>>> Stashed changes
# Destination
dest="/mnt/backup/serverbackups"

# Opret arkiveret fil med tidspunkt/dato
tid=$(date +%d-%m-%Y)
hostname=$(hostname -s)
archive_fil="$hostname-$tid.tgz"

<<<<<<< Updated upstream
# Print besked til konsol
echo "Backing up $backup to $dest/$archive_fil"
date
echo

# Arkiver alle filer/mapper men eksluder nævnte drevs i variablen "exclude_dirs"
tar czf $dest/$archive_fil "${exclude_dirs[@]}" $backup
=======
# Print besked I console
echo "Backup op af $backup til $dest/$archive_fil"
date
echo

# Arkiver/zip fil 
tar czf $dest/$archive_fil $backup
>>>>>>> Stashed changes

# Print status besked
echo
echo "Backup finished"
date

<<<<<<< Updated upstream
# Slet filer ældre end 14 dage via find kommado
=======
# slet filer ældre end 14 dage 
>>>>>>> Stashed changes
find /mnt/backup/serverbackups -type f -mtime +14 -delete
