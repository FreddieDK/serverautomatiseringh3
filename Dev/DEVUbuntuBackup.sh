

sudo -i
apt install nfs-common -y
mkdir /mnt/backup
mount -t nfs 192.168.1.25:/mnt/Storage/Backups /mnt/backup/
mkdir /mnt/backup/(Server Backup Mappe Navn)
touch /backupscript
chmod 700 /backupscript
nano /backupscript

Indsæt:
#START
#!/bin/bash
####################################
#
Backup to NFS mount script.
#
####################################

What to backup.
backup_files="/home /var/spool/mail /etc /root /boot /opt"

Where to backup to.
dest="/mnt/backup/(Server Backup Mappe Navn)"

Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

Backup the files using tar.
tar czf $dest/$archive_file $backup_files

Print end status message.
echo
echo "Backup finished"
date

Long listing of files in $dest to check file sizes.
ls -lh $dest
#STOP

crontab -e
Indsæt:
#START
21 * * * /backupscript
#STOP
systemctl restart cron.service

nano /etc/fstab
#START
192.168.1.25:/mnt/Storage/Backups /mnt/backup/ nfs defaults 0 0
#STOP