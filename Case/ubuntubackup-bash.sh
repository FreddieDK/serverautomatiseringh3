#!/bin/bash

# Mapper og filer der skal sikkerhedskopieres
backup="/home /var/spool/mail /etc /root /boot /opt"

# Destination til backup
dest="/mnt/backup/serverbackups"

# Logfil placering
log_file="/var/log/backup_script.log"

# Opret arkiveret fil med dato og tidspunkt
tid=$(date +%Y-%m-%d-%H-%M)
hostname=$(hostname -s)
archive_fil="$hostname-$tid.tgz"

# Sikrer at destinationsmappen findes
if [ ! -d "$dest" ]; then
    echo "[$(date)] Opretter destinationsmappe: $dest" | tee -a "$log_file"
    mkdir -p "$dest" || { echo "[$(date)] Fejl: Kunne ikke oprette destinationsmappen." | tee -a "$log_file"; exit 1; }
fi

# Print besked i konsol og logfil
echo "[$(date)] Starter sikkerhedskopiering af $backup til $dest/$archive_fil" | tee -a "$log_file"

# Arkiver/zip filer
{
    tar czf "$dest/$archive_fil" $backup
    echo "[$(date)] Sikkerhedskopiering færdig: $dest/$archive_fil" | tee -a "$log_file"
} || {
    echo "[$(date)] Fejl under sikkerhedskopiering." | tee -a "$log_file"
    exit 1
}

# Fjern filer ældre end 14 dage
{
    echo "[$(date)] Fjerner gamle sikkerhedskopier ældre end 14 dage..." | tee -a "$log_file"
    find "$dest" -type f -mtime +14 -delete
    echo "[$(date)] Gamle sikkerhedskopier fjernet." | tee -a "$log_file"
} || {
    echo "[$(date)] Fejl under fjernelse af gamle sikkerhedskopier." | tee -a "$log_file"
    exit 1
}

# Afslut besked
echo "[$(date)] Sikkerhedskopieringsprocessen er afsluttet." | tee -a "$log_file"
