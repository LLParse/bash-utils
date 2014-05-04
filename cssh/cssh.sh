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
usage: $0 [-a [-n]] [-o <options>] (-s <script>) (-c <cmd>) (hosts)+
       $0 -h

Easy execution of commands and scripts across a set of hosts using SSH.

Both a script and command may be specified at once. Scripts execute before 
commands. In asynchronous mode, the command will only execute once the script 
returns 0 and will not execute otherwise.

OPTIONS:
   -a      Asynchronous execution
   -c      Execute command on hosts
   -h      Help: Display usage
   -n      Non-blocking (return immediately)
   -o      SSH Options. Default: 
                 "$SSH_OPTS"
   -s      Execute script on hosts
EOF
exit 1
}

parse_args() {
  ASYNC=false
  WAIT=true
  CMD=
  SCRIPT=
  SSH_OPTS="-oStrictHostKeyChecking=no -oConnectTimeout=5"
  if [ $# -eq 0 ]; then
    usage
  fi
  while getopts "ac:hno:s:" OPTION; do
    case $OPTION in
      a) ASYNC=true;;
      c) CMD=$OPTARG;;
      h) usage;;
      n) WAIT=false;;
      o) SSH_OPTS=$OPTARG && echo "Using SSH Opts: $OPTARG";;
      s) SCRIPT=$OPTARG;;
      ?) echo "Invalid option: -$OPTARG" && usage;;
    esac
  done
  shift "$((OPTIND - 1))"
  HOSTS=("$@")
}

ssh_cmd() {
  ssh ${SSH_OPTS} $1 $2
}

ssh_script() {
  ssh ${SSH_OPTS} $1 'bash -s' -- < $2
}

cssh() {
  for ((i=0; i<${#HOSTS[@]}; i++)); do
    if $ASYNC; then
      if [ -n "$CMD" -a -n "$SCRIPT" ]; then
        ssh_cmd ${HOSTS[i]} $CMD && \
        ssh_script  ${HOSTS[i]} $SCRIPT &
      elif [ -n "$CMD" ]; then
        ssh_cmd ${HOSTS[i]} $CMD &
      elif [ -n "$SCRIPT" ]; then
        ssh_script ${HOSTS[i]} $SCRIPT &
      fi
      # Save process id for blocking
      if $WAIT; then
        pid[i]=$!
      fi
    else
      if [ -n "$CMD" ]; then
        ssh_cmd ${HOSTS[i]} $CMD
      fi
      if [ -n "$SCRIPT" ]; then
        ssh_script ${HOSTS[i]} $SCRIPT
      fi
    fi
  done
  # Block until all processes complete
  if $WAIT && $ASYNC; then
    for ((i=0; i<${#HOSTS[@]}; i++)); do
      wait ${pid[i]}
    done
  fi
}

parse_args $@
cssh
