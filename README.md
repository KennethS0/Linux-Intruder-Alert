# Linux-Intruder-Alert

This repo is just a demonstration of how a file can be stored and only accessed by priviledged users or users within a group and how access to a file can be logged and monitored in real time. 

To simulated real time access being done by an intruder, a cronjob that executes the `./bin/check_access.sh` script every 2 minutes was created. This will allow the user to monitor the log files in real time to see updates. 

## 1. sh files in ./bin/
---
### 1.1 setup.sh

Make sure to execute this file first, as it will set up the `release_team` group, and will add the following users to that group:
- devopslead
- devops_support1 
- devops_support2

It will also create a new user called `intruder` which will be used to try and access the important files set up.

This script will also create the following files and directories:
|Path|Description|Owner|Group|Permissions|
|-----|-------------|---|---|-|
|/srv/releases     |Path that only priviliedges users can access.|devopslead|release_team|drwxrw----|
|/srv/releases/release_notes.txt     |File where the release notes information is kept.|devopslead|release_team|-rw-------|
|/var/log/access_attempts.log|Logs any access attempt by any user. Which can be monitored with `tail -f /var/log/access_attempts.log`| root | root | -rw-rw-rw- |

### 1.2 release_notes_updater.sh
This script constantly adds lines to the `/srv/releases/release_notes.txt` file under the `devopslead` user previously created.

The process created by executing this script can be monitored by executing any of the following commands: 
* `ps`
* `htop`
* `top`

We can also change the priority of this script with the following command:
* `renice -n <priority> -p <process_id>`

### 1.3 check_access.sh
This script accepts a single parameter, which by definition can be any existing or non-existing user. The script will check if the user exists or not and in case it exists, then it will check if it belongs to the `release_team` group. Once that is verified it will show the contents of `/srv/releases/release_notes.txt`.

Any type of access will be logged in `/var/log/access_attempts.log`.

### 2. Setting up the cronjob
---
As an additional task we can also set up a cron job to run every 2 minutes for the /var/log/access_attempts.log to show activity that can be monitored in different ways such as `tail -f /var/log/access_attempts.log`.

In this case we will create the Cronjob under the `root` user.

1. Check the existing Cronjobs that have been created by the user with the following command:
    - `sudo crontab -l -u root`

2. Open the editor if you need to change the cronjob commands:
    - `sudo crontab -u root -e`

3. Add the following command (In this case I will be using the script saved in my private repository, make sure to point to the corret area in your computer):
    - `*/2 * * * * /home/kenneth/Git/Linux-Itruder-Alert/bin/check_access.sh intruder`