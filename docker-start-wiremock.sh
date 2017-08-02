#!/bin/bash

service cron start

start-wiremock-server

head-wiremock

echo "Logging wiremock ..."
tail -f /var/log/wiremock/server.log

echo "Waiting forever ..."
tail -f /dev/null
