#!/bin/bash

RUNNING="$(ps -eaf | grep java | grep zookeeper)"

if ! [[ -z "$RUNNING" ]]; then
  zkServer.sh stop
else
  "Apache Zookeeper Server NOT running ..."
fi
