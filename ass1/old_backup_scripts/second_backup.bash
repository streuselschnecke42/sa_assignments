#!/usr/bin/env bash

# WARNING!! DO NOT EXECUTE!!

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

# SEARCH FOR DIR & TAKE ONLY FIRST FOUND DIR
FILE_PATH=$(find "$HOME" -type d -name "$1" -print -quit 2>/dev/null)

# DIR NOT FOUND -> STRING IS 0 -> REDIRECT ERROR HERE
if [ -z "$FILE_PATH" ]; then
    echo "Directory not found."
    finish_time "$SECONDS"
    exit 1
fi

# CHECK IF FILE ALREADY EXISTS
BACKUP_PATH=$(find "/tmp" -type f -name "backup_$DATUM.tar.gz" 2>/dev/null)
if [ -n "$BACKUP_PATH" ]; then
    echo "Backup file already exists."
    finish_time "$SECONDS"
    exit 1
fi

# CREATE BACKUP
tar -czf backup_"$DATUM".tar.gz "$FILE_PATH" 2>/dev/null

# MOVE FILE WHERE IT SHOULD BE (IN TMP DIR)
cd || exit
sudo mv backup_"$DATUM".tar.gz /tmp 2>/dev/null
echo "backup_$DATUM.tar.gz successfully created :)"
finish_time "$SECONDS"