#!/bin/bash

# This file creates master user, assigns /home/master as home, ssh as user group and sets
#  master as password. Apart from all that, it grants rm, mkdir, chown, useradd, deluser
#  and chpasswd command usages with the help of sudo command. This user now can create a new
#  SSH user and revert what he has done.

set -e

printf "\n\033[0;44m---> Creating SSH user ${SSH_MASTER_USER} ${HOME}\033[0m\n"

#(for mac) Add a group with the same gid as the host user group id
groupadd  ${SSH_MASTER_USER}

# Add a user with the same uid as the owner of the files on the shared volumes
useradd -m -s /bin/bash -u ${HOST_USER_ID} -g ${SSH_MASTER_USER} ${SSH_MASTER_USER}

# Add a group with the same name and id as the main group of the system user of the host
#   and add the new user to this group so that he can write files to the host
# groupadd -g ${HOST_GROUP_ID} ${HOST_GROUP_NAME}
# usermod -a -G ${HOST_GROUP_NAME} ${SSH_MASTER_USER}

echo "${SSH_MASTER_USER}:${SSH_MASTER_PWD}" | chpasswd
echo 'PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/julia/bin"' >> ${HOME}/.profile
chown -R ${SSH_MASTER_USER}:${SSH_MASTER_USER} ${HOME}

echo "${SSH_MASTER_USER} ALL=NOPASSWD:/bin/rm" >> /etc/sudoers
echo "${SSH_MASTER_USER} ALL=NOPASSWD:/bin/mkdir" >> /etc/sudoers
echo "${SSH_MASTER_USER} ALL=NOPASSWD:/bin/chown" >> /etc/sudoers
echo "${SSH_MASTER_USER} ALL=NOPASSWD:/usr/sbin/useradd" >> /etc/sudoers
echo "${SSH_MASTER_USER} ALL=NOPASSWD:/usr/sbin/deluser" >> /etc/sudoers
echo "${SSH_MASTER_USER} ALL=NOPASSWD:/usr/sbin/chpasswd" >> /etc/sudoers
echo "${SSH_MASTER_USER} ALL=NOPASSWD:/usr/bin/vim" >> /etc/sudoers

exec "$@"
