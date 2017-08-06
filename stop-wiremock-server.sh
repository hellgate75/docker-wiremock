#!/bin/bash

RUNNING="$(ps -eaf|grep java| grep 'wiremock-standalone'|grep -v grep|awk 'BEGIN {FS=OFS=" "}{print $2}')"

if ! [[ -z "$RUNNING" ]]; then
  kill -9 $RUNNING
else
  echo "Wiremock Server NOT running ..."
fi
