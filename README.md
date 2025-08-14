# Linux-Intruder-Alert

This repo is just a demonstration of how a file can be stored and only accessed by priviledged users 
or users within a group.

## sh files in bin/

### setup.sh
Make sure to execute this file first, as it will set up the `release_team` group, and will add the following users to that group:
- devopslead
- devops_support1 
- devops_support2

It will also create a new user called `intruder` which will be used to try and access the important files set up.




### Setting up the cronjob
As an additional task we can also set up a cron job to run every 2 minutes
for the /var/log/access_attempts.log to show activity that can be monitored
in different ways such as `tail -f /var/log/access_attempts.log`.

In this case we will create the Cronjob under the root user.

1. Check the existing Cronjobs that have been created by the user with the following command:
    - `sudo crontab -l -u root`

2. Open the editor if you need to change the cronjob commands:
    - `sudo crontab -u root -e`

3. Add the following command (In this case I will be using the script saved in my private repository, make sure to point to the corret area in your computer):
    - `*/2 * * * * /home/kenneth/Git/Linux-Itruder-Alert/bin/check_access.sh intruder`