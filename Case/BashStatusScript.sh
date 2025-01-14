#!/bin/bash

# Variables
LOG_DIR="/var/log/system_metrics"
START_TIME=$(date +%s)
LOG_FILE="$LOG_DIR/system_metrics_$(date +%Y%m%d_%H%M%S).txt"
DURATION=86400 # 24 hours in seconds

# Sikre mappen til log findes
mkdir -p $LOG_DIR

# Beskriv TXT headers
echo "Timestamp,CPU (%),Available Memory (MB),Available Memory (%),Total Disk Space (GB),Used Disk Space (GB),Disk Usage (%),Uptime" > $LOG_FILE

while :
do
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))

    # Stop scripted efter 24 timer
    if [ $ELAPSED -ge $DURATION ]; then
        echo "24 hours elapsed. Stopping the script."
        break
    fi

    # Indsamle system målinger
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    MEM_INFO=$(free -m | grep Mem:)
    TOTAL_MEM=$(echo $MEM_INFO | awk '{print $2}')
    USED_MEM=$(echo $MEM_INFO | awk '{print $3}')
    AVAILABLE_MEM=$((TOTAL_MEM - USED_MEM))
    AVAILABLE_MEM_PERCENT=$(awk "BEGIN {printf \"%.1f\", ($AVAILABLE_MEM/$TOTAL_MEM)*100}")

    DISK_INFO=$(df -h / | tail -1)
    TOTAL_DISK=$(echo $DISK_INFO | awk '{print $2}' | sed 's/G//')
    USED_DISK=$(echo $DISK_INFO | awk '{print $3}' | sed 's/G//')
    DISK_USAGE=$(echo $DISK_INFO | awk '{print $5}' | sed 's/%//')

    UPTIME=$(awk '{printf "%.5f", $1 / 3600}' /proc/uptime)

    # Formater log entry'en
    LOG_ENTRY="$TIMESTAMP,$CPU_USAGE,$AVAILABLE_MEM,$AVAILABLE_MEM_PERCENT,$TOTAL_DISK,$USED_DISK,$DISK_USAGE,$UPTIME"

    # Tilføj log entry'en til TXT filen
    echo $LOG_ENTRY >> $LOG_FILE

    # Fremvis de nuværende målinger i consollen
    echo "$TIMESTAMP > CPU: $CPU_USAGE%, Avail. Mem.: ${AVAILABLE_MEM}MB (${AVAILABLE_MEM_PERCENT}%), Disk: ${USED_DISK}GB/${TOTAL_DISK}GB (${DISK_USAGE}%), Uptime(Hours): $UPTIME"

    # Pause i 2 sekunder før næste iteration
    sleep 2

done
