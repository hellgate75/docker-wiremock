#!/bin/bash

RUNNING="$(ps -eaf | grep java | grep zookeeper)"

if ! [[ -z "$RUNNING" ]]; then
  echo "running"
else
  echo "stopped"
fi
