#!/bin/bash

if [[ ! -z "$(echo $3|grep "\-daemon")" || -z "$1" ]]; then
  echo "Running docker WireMock Server ..."
  chmod 777 /docker-start-wiremock.sh
  /docker-start-wiremock.sh -daemon
else
  echo "Executing command : $@"
  exec "$@"
fi
