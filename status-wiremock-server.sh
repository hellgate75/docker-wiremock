#!/bin/bash

RUNNING="$(ps -eaf|grep java| grep 'wiremock-standalone'|grep -v grep|awk 'BEGIN {FS=OFS=" "}{print $2}')"

if ! [[ -z "$RUNNING" ]]; then
  echo "running"
else
  echo "stopped"
fi
