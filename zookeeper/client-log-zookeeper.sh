#!/bin/bash

function system_log() {
  mkdir -p /var/log/zookeeper
  echo "[$(date)] $1" >> /var/log/zookeeper/logging-client.log
}
system_log "Zookepeer Logging Client running ..."
zkCli.sh create $CURRENT_SERVER_PATH
zkCli.sh set $CURRENT_SERVER_PATH "$(date)"
zkCli.sh create $CURRENT_SERVER_PATH/$CURRENT_SERVER_ID
zkCli.sh set $CURRENT_SERVER_PATH/$CURRENT_SERVER_ID "$(date)"
