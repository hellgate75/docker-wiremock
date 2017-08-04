#!/bin/bash

function system_log() {
  mkdir -p /var/log/zookeeper
  echo "[$(date)] $1" >> /var/log/zookeeper/logging-client.log
}

system_log "Zookepeer Logging Client running ..."
