Cluster SSH (CSSH)
===============

This utility provides a means of executing commands and scripts across a cluster of hosts.
By default, these services are executed synchronously. The *-a* flag may be specified for
asynchronous execution, which will dramatically reduce execution time in almost all cases.

#Usage
```
Usage: ./cssh [-a [-n]] [-o <options>] -s <script> hosts...
       ./cssh [-a [-n]] [-o <options>] -c <command> hosts...
       ./cssh -h

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
                 "-oStrictHostKeyChecking=no -oConnectTimeout=5"
   -s      Execute script on hosts
```

#Operation Systems Officially Supported
MacOS X 10.8
Ubuntu 12.04 LTS

#Installation
##Local Machine
```bash
REPO_DIR=/tmp/bash-utils

git clone https://github.com/Xerxes500/bash-utils.git $REPO_DIR
sudo cp -f $REPO_DIR/cssh/cssh.sh /usr/bin/cssh
rm -rf $REPO_DIR
```
##Remote Machine / Cluster
Change the CLUSTER variable to match the hosts in your cluster.
```bash
CLUSTER=$(echo host{1..3}.example.com host42.example.com)
REPO_DIR=/tmp/bash-utils

git clone https://github.com/Xerxes500/bash-utils.git $REPO_DIR
pushd $REPO_DIR
  cssh/install.sh $CLUSTER
popd
rm -rf $REPO_DIR
```

