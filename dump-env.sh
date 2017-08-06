#!/usr/bin/env bash
env | grep -v '_=' > /root/.wiremock/.env
sed 's/^/export /g' /root/.wiremock/.env
chmod 777 /root/.wiremock/.env
