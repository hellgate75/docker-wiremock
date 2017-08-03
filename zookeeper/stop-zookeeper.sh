#!/bin/bash

RUNNING="$(ps -eaf | grep java | grep zookeeper)"

if ! [[ -z "$RUNNING" ]]; then
  cd /usr/lib/zookeeper

  $ZK_HOME/bin/zkServer.sh stop
else
  "Wiremock Server NOT running ..."
fi
