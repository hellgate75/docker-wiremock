#!/bin/bash

function system_log() {
  mkdir -p /var/log/zookeeper
  echo "[$(date)] $1" >> /var/log/zookeeper/logging-client.log
}
system_log "Zookepeer Logging Client running ..."
set-node-zookeeper $CURRENT_SERVER_PATH "$(date)" $ZOOKEEPER_SERVER_ADDRESS
set-node-zookeeper $CURRENT_SERVER_PATH/$CURRENT_SERVER_ID "$(date)" $ZOOKEEPER_SERVER_ADDRESS
system_log "Zookepeer Logging Client complete!!"
