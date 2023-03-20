#!/bin/bash

backup_scripts_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
paths_to_backup="PATH_TO_MY_DIR1 PATH_TO_MY_DIR2"

BORG_REPO1=MY_REPO_URL
#BORG_REMOTE_PATH1=/usr/local/bin/borg
BORG_PASSPHRASE1='MY_REPO_PASSPHRASE'

file_for_exit_status_code1="$backup_scripts_dir/backup1_exit_status_code"

