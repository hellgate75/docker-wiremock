#!/bin/bash


function system_log() {
  mkdir -p /var/log/zookeeper
  echo "[$(date)] $1" >> /var/log/zookeeper/seek-config-client.log
}

system_log "Zookepeer Configuration Client running ..."
