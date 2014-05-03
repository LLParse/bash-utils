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
  echo "CSSH Terminated Abnormally"
  exit 1
}

usage() {
cat << EOF
usage: $0 [-a] (-c <cmd>|-s <script>) (hosts)+
       $0 -h

Easy execution of commands and scripts across a set of hosts using SSH.

OPTIONS:
   -a      Asynchronous execution
   -c      Execute command on hosts
   -h      Display usage
   -s      Execute script on hosts
EOF
exit 1
}

parse_args() {
  ASYNC=false
  CMD=
  SCRIPT=
  SSH_OPTS="-oStrictHostKeyChecking=no"
  if [ $# -eq 0 ]; then
    usage
  fi
  while getopts "ac:hs:" OPTION; do
    case $OPTION in
      a) ASYNC=true;;
      c) CMD=$OPTARG;;
      h) usage;;
      s) SCRIPT=$OPTARG;;
      ?) echo "Invalid option: -$OPTARG" && usage;;
    esac
  done
  shift "$((OPTIND - 1))"
  HOSTS=("$@")
}

wait_to_finish() {
  if $ASYNC; then
    for ((i=0; i<${#HOSTS[@]}; i++)); do
      wait ${pid[i]}
    done
  fi
}

exec_command() {
  for ((i=0; i<${#HOSTS[@]}; i++)); do
    if $ASYNC; then
      ssh ${SSH_OPTS} ${HOSTS[i]} $CMD &
      pid[i]=$!
    else
      ssh ${SSH_OPTS} ${HOSTS[i]} $CMD
    fi
  done
  wait_to_finish
}

exec_script() {
  for ((i=0; i<${#HOSTS[@]}; i++)); do
    if $ASYNC; then
      ssh ${SSH_OPTS} ${HOSTS[i]} 'bash -s' -- < $SCRIPT &
      pid[i]=$!
    else
      ssh ${SSH_OPTS} ${HOSTS[i]} 'bash -s' -- < $SCRIPT
    fi
  done
  wait_to_finish
}

cssh() {
  if [ -n "$CMD" ]; then
    exec_command
  elif [ -n "$SCRIPT" ]; then
    exec_script
  else
    echo "No command or script provided."
    usage
  fi
}

parse_args $@
cssh
