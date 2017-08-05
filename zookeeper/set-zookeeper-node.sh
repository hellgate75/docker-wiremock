#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Usage: set-node-zookeer node-path value [server:port]"
  exit 1
fi
DATA="$(zkCli.sh get $1 | grep -vi java | grep -vi connect| grep -vi watcher| grep -vi exception)"
CONNECT=""
if ! [[ -z "$3" ]]; then
  CONNECT=" -server $3"
fi
if [[ -z "$DATA" ]]; then
  zkCli.sh$CONNECT create "$1"
fi
zkCli.sh$CONNECT set "$1" "$2"
