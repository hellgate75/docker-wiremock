#!/bin/bash

start-wiremock-server

sleep 2

head-wiremock

echo "Logging wiremock ..."
tail -f /var/log/wiremock/server.log

echo "Waiting forever ..."
tail -f /dev/null
