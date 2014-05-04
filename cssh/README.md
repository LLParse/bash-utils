Cluster SSH (CSSH)
===============

This utility provides a means of executing commands and scripts across a cluster of hosts.
By default, these services are executed synchronously. The *-a* flag may be specified for
asynchronous execution, which will dramatically reduce execution time in almost all cases.

#Usage
```
usage: ./cssh.sh [-a [-n]] [-o <options>] (-s <script>) (-c <cmd>) (hosts)+
       ./cssh.sh -h

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

#Installation
##Unix Machine
```bash
REPO_DIR=/tmp/bash-utils

git clone https://github.com/Xerxes500/bash-utils.git $REPO_DIR
sudo cp -f $REPO_DIR/cssh/cssh.sh /usr/bin/cssh
rm -rf $REPO_DIR
```
##Unix Cluster
Change the HOSTS variable to match the hosts in your cluster.
```bash
HOSTS=(host1.example.com host2.example.com host3.example.com)
REPO_DIR=/tmp/bash-utils

git clone https://github.com/Xerxes500/bash-utils.git $REPO_DIR
pushd $REPO_DIR
  cssh/cssh_install.sh ${HOSTS[@]}
popd
rm -rf $REPO_DIR
```

