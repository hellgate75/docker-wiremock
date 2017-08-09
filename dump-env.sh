#!/usr/bin/env bash
env | grep -v '_=' > /root/.wiremock/.env
sed -i 's/^/export /g' /root/.wiremock/.env
chmod 777 /root/.wiremock/.env
