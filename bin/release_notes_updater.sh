#!/bin/bash

# This script will simulate a user accessing and updating the /srv/releases/release_notes.txt file.
echo "Executing release notes file updater..."
while true; do
    USER="devopslead"
    sudo su $USER -c 'echo "Release $(date)" >> /srv/releases/release_notes.txt'
    sleep "$(($RANDOM % 10))"
done