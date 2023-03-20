#!/bin/bash

# ############################################################## #
# This script does not need to be adapted to a given environment #
# ############################################################## #

# ####################################################################################################################################### #
# # For the crontab, adapt the following:                                                                                                 #
# 00 21 * * * /home/merchmgt_prod/merchmgt-docker/misc/backup1.sh >> /home/merchmgt_prod/merchmgt-docker/misc/backup1.log  2>&1 #
# ####################################################################################################################################### #

# cd to the directory containing this script
backup_scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $backup_scripts_dir

source config.sh

# Load the variables used by backup-core.sh
file_for_exit_status_code=$file_for_exit_status_code1
export BORG_REPO=$BORG_REPO1
#export BORG_REMOTE_PATH=$BORG_REMOTE_PATH1
export BORG_PASSPHRASE=$BORG_PASSPHRASE1

source ./backup-core.sh

