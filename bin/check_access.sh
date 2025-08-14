#!/bin/bash

# Security measures to avoid prevent access to the file.
CURRENT_USER=$(whoami)
if [[ $CURRENT_USER != "root" && ! " $(id -nG) " =~ " release_team " ]]; then
    echo "You do not have access to run this script."
    echo "[$(date)] User: $CURRENT_USER tried to access /srv/releases/release_notes.txt" >> /var/log/access_attempts.log
    exit 1
fi

# Redirects std err to std out and std out to /dev/null. To avoid any unnecessary log messages.
if id "$1" >/dev/null 2>&1; then
    
    # Check for release_team in user groups
    if id -nG "$1" | grep -qw "release_team"; then
        echo "Access granted"
        echo "[$(date)] User: $CURRENT_USER accessed under the user $1 /srv/releases/release_notes.txt" >> /var/log/access_attempts.log
        su devopslead -c "cat /srv/releases/release_notes.txt"
    else
        echo "Access denied"
        echo "[$(date)] User: $CURRENT_USER tried to access /srv/releases/release_notes.txt under the user $1" >> /var/log/access_attempts.log
    fi
else
    echo "User $1 does not exist."
fi