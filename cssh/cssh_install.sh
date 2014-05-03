#!/bin/bash -Eu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author: James Oliver
# Date:   2014-05-03
#
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
