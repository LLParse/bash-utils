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
  echo "SSH No Password Exited Abnormally"
  exit 1
}

PUBKEY=~/.ssh/id_rsa.pub
SSH_OPTS="-o StrictHostKeyChecking=no -q"

key-test() {
  if [ ! -f $PUBKEY ]; then
    echo "Creating KeyPair on `hostname`.."
    ssh-keygen
  fi
}

no-pass() {
  for host in "$@"; do
    echo "Configuring password-less SSH on $host.."
    scp $PUBKEY $host:~
    ssh ${SSH_OPTS} $host "`echo ~/.ssh/id_rsa.pub` >> ~/.ssh/authorized_keys2"
  done
}

if [ ! -f $PUBKEY ]; then
  echo "Creating KeyPair on `hostname`.."
  ssh-keygen
fi

key-test
no-pass "$@"

