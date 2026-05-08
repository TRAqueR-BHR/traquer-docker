#!/bin/bash
set -e

printf "\n\033[0;44m---> Starting the ssh server.\033[0m\n"

service ssh start
service ssh status

if [ -x /usr/local/bin/install-linuxbrew-if-needed.sh ]; then
  /usr/local/bin/install-linuxbrew-if-needed.sh
fi

exec "$@"
