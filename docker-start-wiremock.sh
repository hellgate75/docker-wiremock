#!/bin/bash

ZOOKERPER_ACTIVE="$(ps -eaf | grep java | grep zookeeper)"

if [[ "yes" == "$ZOOKEEPER_CLIENT_SERVICE" ]]; then

  service cron start

  if [[ "yes" == "$ZOOKEEPER_SERVER_SERVICE" ]]; then
    if [[ -z "$ZOOKERPER_ACTIVE" ]]; then
      echo "Configuring Apache Zookeeper v. $ZOOKEEPER_RELEASE ..."
      if ! [[ -e /root/.zookeeper_configured ]]; then
        configure-zookeeper
        touch /root/.zookeeper_configured
      fi
    fi
  fi
fi


start-wiremock-server

sleep 1

head-wiremock

if [[ "yes" == "$ZOOKEEPER_CLIENT_SERVICE" ]]; then
  if [[ "yes" == "$ZOOKEEPER_SERVER_SERVICE" ]]; then
    if [[ -z "$ZOOKERPER_ACTIVE" ]]; then
      echo "Configuring Apache Zookeeper v. $ZOOKEEPER_RELEASE ..."
      start-zookeeper
      head-zookeeper
    fi
  fi
  ##check and Plan chrontab for client operation
fi


echo "Logging wiremock ..."
tail -f /var/log/wiremock/server.log

echo "Waiting forever ..."
tail -f /dev/null
