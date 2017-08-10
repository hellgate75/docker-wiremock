#!/usr/bin/env bash
env | grep -v '_=' > /root/.zookeeper/.env
sed -i 's/^/export /g' /root/.zookeeper/.env
chmod 777 /root/.zookeeper/.env
