#!/usr/bin/env bash

RUNNING="$(ps -eaf | grep java | grep zookeeper)"

if ! [[ -z "$RUNNING" ]]; then
  echo "Apache Zookeeper already running!!"
  exit 0
fi

function download_file() {
  if [[ -z "$(echo $2|grep -i 'https://')" ]]; then
    curl -L -o $1 $2
    return "$?"
  else
    curl -sSL -o $1 $2
    return "$?"
  fi
}

if ! [[ -z "$ZOOKEEPER_CONFIGURATION_URL" ]]; then
  echo "Downloading Apache ZooKeeper configuration from url : $ZOOKEEPER_CONFIGURATION_URL ..."
  download_files /root/zoo-dwld.cfg $ZOOKEEPER_CONFIGURATION_URL
  if [[ -e /root/zoo-dwld.cfg ]]; then
    echo "Applying Apache ZooKeeper download configuration ..."
    cp /root/zoo-dwld.cfg $ZK_HOME/conf/zoo.cfg
    rm -f /root/zoo-dwld.cfg
  else
    echo "Problems downloading Apache ZooKeeper configuration from url : $ZOOKEEPER_CONFIGURATION_URL ..."
  fi
else
 if ! [[ -z "$ZOOKEEPER_CONFIGURATION_SCRIPT_URL" ]]; then
   echo "Downloading Apache ZooKeeper configuration shell script from url : $ZOOKEEPER_CONFIGURATION_SCRIPT_URL ..."
   download_files /root/setup-zookeeper.sh $ZOOKEEPER_CONFIGURATION_SCRIPT_URL
   if [[ -e /root/setup-zookeeper.sh ]]; then
     echo "Applying Apache ZooKeeper downloaded shell script configuration ..."
     . /root/setup-zookeeper.sh
     rm -f /root/setup-zookeeper.sh
   else
     echo "Problems downloading Apache ZooKeeper configuration shell script from url : $ZOOKEEPER_CONFIGURATION_SCRIPT_URL ..."
   fi
 fi
   configure-zookeeper
fi

cd $ZOOKEEPER_HOME

if [[ -z "$RUNNING" ]]; then
  echo "Starting Apache ZooKeeper ..."
  zkServer-initialize.sh --force
  zkEnv.sh && zkServer.sh start
fi
