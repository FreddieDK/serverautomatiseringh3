#!/bin/bash
####################################
#
# Prune old backups based on retention policy.
#
####################################

# Backup directory.
backup_dir="/mnt/backup/(Server Backup Mappe Navn)"

# Retention policy.
keep_daily=7       # Number of daily backups to keep.
keep_weekly=4      # Number of weekly backups to keep.
keep_monthly=12    # Number of monthly backups to keep.
keep_yearly=3      # Number of yearly backups to keep.

# Find backups and sort them.
cd "$backup_dir" || exit 1

# Daily backups.
find . -maxdepth 1 -type f -name "*.tgz" -printf "%T@ %p\n" | \
  sort -nr | awk "NR>$keep_daily { print \$2 }" | xargs -I {} rm -f {}

# Weekly backups (created on Sundays).
find . -maxdepth 1 -type f -name "*.tgz" -printf "%T@ %p\n" | \
  grep "$(date --date='last sunday' +'%Y%m%d')" | sort -nr | \
  awk "NR>$keep_weekly { print \$2 }" | xargs -I {} rm -f {}

# Monthly backups (created on the first of the month).
find . -maxdepth 1 -type f -name "*.tgz" -printf "%T@ %p\n" | \
  grep "$(date --date='last month' +'%Y%m01')" | sort -nr | \
  awk "NR>$keep_monthly { print \$2 }" | xargs -I {} rm -f {}

# Yearly backups (created on the first of the year).
find . -maxdepth 1 -type f -name "*.tgz" -printf "%T@ %p\n" | \
  grep "$(date --date='last year' +'%Y0101')" | sort -nr | \
  awk "NR>$keep_yearly { print \$2 }" | xargs -I {} rm -f {}
