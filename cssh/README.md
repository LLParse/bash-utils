Cluster SSH (CSSH)
===============

This utility provides a means of executing commands and scripts across a cluster of hosts.
By default, these services are executed synchronously. The -a flag may be specified if a-
synchronous execution is desired. This dramatically reduces execution time in most cases.

#Usage
```
usage: cssh [-a] (-c <cmd>|-s <script>) (hosts)+

Easy execution of commands and scripts across a set of hosts using SSH.

OPTIONS:
   -a      Asynchronous execution
   -c      Execute command on hosts
   -h      Display usage
   -s      Execute script on hosts
```

#Installation
```bash
HOSTS=(host1.example.com host2.example.com host3.example.com)
REPO_DIR=/tmp/bash-utils

git clone https://github.com/Xerxes500/bash-utils.git $REPO_DIR
pushd $REPO_DIR
  cssh/cssh_install.sh ${HOSTS[@]}
popd
rm -rf $REPO_DIR
```

