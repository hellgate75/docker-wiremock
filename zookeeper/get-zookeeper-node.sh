#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "Usage: get-node-zookeer node-path [server:port]"
  exit 1
fi
CONNECT=""
if ! [[ -z "$2" ]]; then
  CONNECT=" -server $2"
fi
DATA="$(zkCli.sh$CONNECT get $1 | grep -vi java | grep -vi connect| grep -vi watcher| grep -vi exception)"
echo "$(echo $DATA|sed 's/\n//g')"
