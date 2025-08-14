#!/bin/bash


# This script serves the purpose of creating the environment and necessary files for
# the project to execute.

# ============== Groups and Users ======================

# It will create the following Groups and user structure:
# - release-team (Group):
#   -  devopslead (User)
#   -  devops_support1 (User)
#   -  devops_support (User)
# 
# - intruder (User)

# Group that will have access to the important files.
if ! grep -q "release_team" /etc/group; then
    sudo groupadd release_team
else
    echo "Skipping creation of 'release_team' group..."
fi


# Users creation in release_team.
USERS=("devopslead" "devops_support1" "devops_support2")
for USER in ${USERS[@]}; do

    # Create user
    if ! id $USER >/dev/null 2>&1; then
        sudo useradd $USER
        sudo passwd $USER
    else
        echo "Skipping creation of '$USER'..."
    fi

    # Add to release_team group
    sudo usermod -aG release_team $USER
done


# This user will is not supposed to have access to the files.
if ! id intruder >/dev/null 2>&1; then
    sudo useradd intruder
else
    echo "Skipping creation of 'intruder'..."
fi

# ================ File Creation ===================

# The following file structure will be created: 

# /srv/releases (-rw-r----- devopslead release_team)
#     - release_notes.txt (-rw-r----- devopslead release_team)


if [[ ! -d /srv/releases ]]; then
    sudo mkdir /srv/releases
    sudo chown devopslead:release_team /srv/releases
    sudo chmod 760 /srv/releases
fi

sudo su devopslead -c 'touch /srv/releases/release_notes.txt && chmod 600 /srv/releases/release_notes.txt && chgrp release_team /srv/releases/release_notes.txt'

# Access log file
if [[ ! -f /var/log/access_attempts.log ]]; then
    sudo touch /var/log/access_attempts.log
    sudo chmod 666 /var/log/access_attempts.log
fi