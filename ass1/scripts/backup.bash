#!/usr/bin/env bash

finish_time () {
    DURATION=$1
    MIN=$((DURATION / 60))
    SEC=$((DURATION % 60))
    echo "Execution time: $MIN minutes and $SEC seconds"
}

# START TIMER
SECONDS=0

# IF INPUT IS NOT 1 ARGUMENT
if [ "$#" -ne 1 ]; then
    echo "Invalid amount of arguments. Enter: bash path/to/backup.bash <dirname>"
    # 1 MEANS FAILURE (THATS BAD)
    finish_time "$SECONDS"
    exit 1
fi

# GET DATE
DATUM=$(date +%Y-%m-%d)

# GO HOME (JUST TO BE SAFE)
cd || exit

# -d TRUE IF PATH EXISTS AND IS DIR; IF NOT -> PRINT ERROR EXITCODE: FAIL
if [ ! -d "$1" ]; then
    echo "Directory not found."
    finish_time "$SECONDS"
    exit 1
fi

# CHECK IF FILE ALREADY EXISTS
if [ -f "/tmp/backup_$DATUM.tar.gz" ]; then
    echo "Backup file already exists."
    finish_time "$SECONDS"
    exit 1
fi

# CREATE BACKUP
tar -czf backup_"$DATUM".tar.gz "$1" 2>/dev/null || { echo "backup_$DATUM.tar.gz creation failed :("; exit 1; }

# MOVE FILE WHERE IT SHOULD BE (IN TMP DIR)
cd || exit
mv backup_"$DATUM".tar.gz /tmp 2>/dev/null
echo "backup_$DATUM.tar.gz creation success"
finish_time "$SECONDS"