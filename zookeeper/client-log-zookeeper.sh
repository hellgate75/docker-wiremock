#!/usr/bin/env bash

set -ae

. setenv-zookeeper
. custom-setenv-zookeeper

function system_log() {
  mkdir -p /var/log/zookeeper
  echo -e "[$(date)] $1\n" >> /var/log/zookeeper/logging-client.log
}

system_log "Zookepeer Logging Client running ..."
system_log "Zookepeer Logging Accessing to server at : $ZOOKEEPER_SERVER_ADDRESS"
ADDRPATH=""
ADDRPATH_BLOCKS=""
export IFS="/";read -ra ADDRPATH_BLOCKS <<< "$CURRENT_SERVER_PATH"
for hour in "${ADDRPATH_BLOCKS[@]}"; do
  if ! [[ -z "$ADDRPATH_BLOCKS" ]]; then
    ADDRPATH="$ADDRPATH/$ADDRPATH_BLOCKS"
    set-node-zookeeper "$ADDRPATH" "$(date -I'ns')" "$ZOOKEEPER_SERVER_ADDRESS"
  fi
done
SERVER_PATH="$CURRENT_SERVER_PATH"
if [[ "/" != "${SERVER_PATH:0:1}" ]]; then
  SERVER_PATH="/$SERVER_PATH"
fi
set-node-zookeeper "$SERVER_PATH/$CURRENT_SERVER_ID" "$(date -I'ns')" "$ZOOKEEPER_SERVER_ADDRESS"
system_log "Zookepeer Logging Client complete!!"
