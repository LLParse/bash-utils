#!/bin/bash -Eu
trap error 1 2 3 15 ERR

error() {
  echo "CSSH Installation Failed"
  exit 1
}

SSH_OPTS="-o StrictHostKeyChecking=no -q"
SCP_OPTS="-q"
SCRIPT=cssh.sh
PATH_CMD=/usr/bin/cssh

install() {
  if [ -f $SCRIPT ]; then
    for host in "$@"; do
      echo "Installing $SCRIPT to $PATH_CMD on $host..."
      scp ${SCP_OPTS} $SCRIPT $host:$TMP && \
        ssh ${SSH_OPTS} $host "sudo mv -f /tmp/$SCRIPT $PATH_CMD"
    done
  else
    echo "Could not find script to be installed: $SCRIPT"
  fi
}

install $@