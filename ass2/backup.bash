#!/usr/bin/env bash

# GO HOME (JUST TO BE SAFE)
cd || exit

# -d TRUE IF PATH EXISTS AND IS DIR; IF NOT -> PRINT ERROR EXITCODE: FAIL
if [[ ! -d /home/ubuntu || ! -d /var/www || ! -d /etc/apache2 ]]; then
    echo "Directory not found."
    exit 1
fi

# CHECK IF FILE ALREADY EXISTS -> REPLACE IF SO
if [ -f "/home/ubuntu/backup.tar.gz" ]; then
    echo "Overwriting old backup."
    sudo rm -rf /home/ubuntu/backup.tar.gz
fi

# CREATE BACKUP
# C = CREATE; Z = GZIP; F = NEXT ARGUMENT WILL BE NEW NAME OF FILE
sudo tar -czf backup.tar.gz /var/www /etc/apache2 2>/dev/null || { echo "backup.tar.gz creation failed :("; exit 1; }

# MOVE FILE WHERE IT SHOULD BE (IN $HOME DIR)
cd || exit
mv backup.tar.gz /home/ubuntu 2>/dev/null
echo "backup.tar.gz creation success"
