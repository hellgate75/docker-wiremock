#!/bin/bash

function download_file() {
  if [[ -z "$(echo $2|grep -i 'https://')" ]]; then
    curl -L -o $1 $2
    return "$?"
  else
    curl -sSL -o $1 $2
    return "$?"
  fi
}


function apply_config() {
  # replace in place text in $1 with $2 in file $3
  sed -i s/$1/$2/g $3
}

echo "Configuring ZooKeeper ..."
export CONFIGURATION=false
if ! [[ -z "$ZOOKEEPER_CONFIGURATION_URL" ]]; then
  echo "Configuring Apache Zookeeper v. $ZOOKEEPER_RELEASE via URL : $ZOOKEEPER_CONFIGURATION_URL ..."
  download_file $ZOOKEEPER_HOME/conf/zoo.cfg $ZOOKEEPER_CONFIGURATION_URL
  export URL_EXIT_CODE="$?"
  if [[ "0" == "$URL_EXIT_CODE" ]]; then
    echo "URL configuration recovered succesfully!!"
    export CONFIGURATION=true
  else
    echo "Error [$URL_EXIT_CODE] retrieving configuration from URL : $ZOOKEEPER_CONFIGURATION_URL"
    exit $URL_EXIT_CODE
  fi
fi
if [[ "false" == "$CONFIGURATION" ]]; then
  echo "Configuring Apache Zookeeper v. $ZOOKEEPER_RELEASE via PARAMETERS ..."
  LEADER_SERVER="yes"
  if [[ "true" != "$ZK_REPLICA_LEADER_SERVES" ]]; then
    LEADER_SERVER="no"
  else
    LEADER_SERVER="yes"
  fi
  if [[ "true" != "$ZOOKEEPER_SYNC_ENABLED" ]]; then
    export ZOOKEEPER_SYNC_ENABLED="false"
  fi
  if [[ "false" != "$ZK_STANDALONE_MODE" ]]; then
    export ZK_STANDALONE_MODE="true"
  fi
  if [[ "true" == "$ZK_STANDALONE_MODE" ]]; then
    echo "Apache Zookeeper v. $ZOOKEEPER_RELEASE mode : Standalone"
    sed -e s/TICK_TIME/$ZOOKEEPER_TICK_TIME/g $ZOOKEEPER_HOME/conf/zoo.cfg.standalone.template | sed -e s/CLIENT_PORT/$ZOOKEEPER_PORT/g | \
    sed -e s/SECURE_PORT/$ZOOKEEPER_SECURE_PORT/g | sed -e s/OUTSTANDING_LIMIT/$ZOOKEEPER_OUTSTANDING_LIMIT/g | \
    sed -e s/PRE_ALLOC_SIZE/$ZOOKEEPER_PREALLOC_SIZE_KBS/g | sed -e s/SNAP_COUNT/$ZOOKEEPER_SNAP_COUNT/g | \
    sed -e s/MAX_CLINT_CONNS/$ZOOKEEPER_MAX_CLIENT_CONNECTIONS/g | \
    sed -e s/MIN_SESSION_TIMEOUT/$ZOOKEEPER_MIN_SESSION_TIMEOUT/g | sed -e s/MAX_SESSION_TIMEOUT/$ZOOKEEPER_MAX_SESSION_TIMEOUT/g | \
    sed -e s/WARNING_THRESHOLD/$ZOOKEEPER_FSYNC_WARNING_THRD/g | sed -e s/SNAP_RETAIN_COUNT/$ZOOKEEPER_SNAP_RETAIN_COUNT/g | \
    sed -e s/PURGE_INTERVAL/$ZOOKEEPER_AUTOPURGE_INTERVAL/g | sed -e s/SYNC_ENABLED/$ZOOKEEPER_SYNC_ENABLED/g | \
    sed -e s/INIT_LIMIT/$ZK_REPLICA_INIT_LIMIT/g | sed -e s/SYNC_LIMIT/$ZK_REPLICA_SYNC_LIMIT/g  >  $ZOOKEEPER_HOME/conf/zoo.cfg
  else
    echo "Apache Zookeeper v. $ZOOKEEPER_RELEASE mode : Replica"
    sed -e s/TICK_TIME/$ZOOKEEPER_TICK_TIME/g $ZOOKEEPER_HOME/conf/zoo.cfg.replica.template | sed -e s/CLIENT_PORT/$ZOOKEEPER_PORT/g | \
    sed -e s/SECURE_PORT/$ZOOKEEPER_SECURE_PORT/g | sed -e s/OUTSTANDING_LIMIT/$ZOOKEEPER_OUTSTANDING_LIMIT/g | \
    sed -e s/PRE_ALLOC_SIZE/$ZOOKEEPER_PREALLOC_SIZE_KBS/g | sed -e s/SNAP_COUNT/$ZOOKEEPER_SNAP_COUNT/g | \
    sed -e s/MAX_CLINT_CONNS/$ZOOKEEPER_MAX_CLIENT_CONNECTIONS/g | sed -e s/CONN_TIMEOUT/$ZOOKEEPER_CONNECTIONS_TIMEOUT/g | \
    sed -e s/MIN_SESSION_TIMEOUT/$ZOOKEEPER_MIN_SESSION_TIMEOUT/g | sed -e s/MAX_SESSION_TIMEOUT/$ZOOKEEPER_MAX_SESSION_TIMEOUT/g | \
    sed -e s/WARNING_THRESHOLD/$ZOOKEEPER_FSYNC_WARNING_THRD/g | sed -e s/SNAP_RETAIN_COUNT/$ZOOKEEPER_SNAP_RETAIN_COUNT/g | \
    sed -e s/PURGE_INTERVAL/$ZOOKEEPER_AUTOPURGE_INTERVAL/g | sed -e s/STANDALONE/$ZK_STANDALONE_MODE/g | \
    sed -e s/SYNC_ENABLED/$ZOOKEEPER_SYNC_ENABLED/g | sed -e s/ELECTION_ALG/$ZK_REPLICA_ELECTION_ALG/g | \
    sed -e s/INIT_LIMIT/$ZK_REPLICA_INIT_LIMIT/g | sed -e s/SYNC_LIMIT/$ZK_REPLICA_SYNC_LIMIT/g | \
    sed -e s/LEADER_SERVER/$LEADER_SERVER/g  >  $ZOOKEEPER_HOME/conf/zoo.cfg
    if [[ "3" ==  "$ZK_REPLICA_ELECTION_ALG" ]]; then
      if ! [[ -z "$ZK_CLUSER_LEADER_ELECTION_TIMEOUT" ]]; then
        echo "cnxTimeout=$ZK_CLUSER_LEADER_ELECTION_TIMEOUT" >>  $ZOOKEEPER_HOME/conf/zoo.cfg
      fi
    fi
    if ! [[ -z "$ZK_CLUSER_SERVERS" ]]; then
      COUNTER=1
      IFS=";";for server in $ZK_CLUSER_SERVERS; do
        if ! [[ -z "$server"  ]]; then
          echo "server.$COUNTER=$server"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
          let COUNTER++
        fi
      done
    fi
    if ! [[ -z "$ZK_CLUSER_SERVER_GROUPS" ]]; then
      COUNTER=1
      IFS=";";for group in $ZK_CLUSER_SERVER_GROUPS; do
        if ! [[ -z "$group"  ]]; then
          echo "group.$COUNTER=$group"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
          let COUNTER++
        fi
      done
    fi
    if ! [[ -z "$ZK_CLUSER_SERVER_WEIGHTS" ]]; then
      COUNTER=1
      IFS=";";for weight in $ZK_CLUSER_SERVER_WEIGHTS; do
        if ! [[ -z "$weight"  ]]; then
          echo "weight.$COUNTER=$weight"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
          let COUNTER++
        fi
      done
    fi
  fi
  if [[ -z "$ZOOKEEPER_SECURE_PORT" ]]; then
    sed -i s/secureClientPort=/\\\#secureClientPort=/g $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  if [[ -z "$ZOOKEEPER_PORT" ]]; then
    sed -i s/clientPort=/\\\#clientPort=/g $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  if ! [[ -z "$ZOOKEEPER_PORT_ADDRESS" ]]; then
    echo "clientPortAddress=$ZOOKEEPER_PORT_ADDRESS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  if [[ "true" != "$ZK_SECURITY_ENABLED" ]]; then
    export ZK_SECURITY_ENABLED="false"
  fi
  if [[ "true" == "$ZK_SECURITY_ENABLED" ]]; then
    if ! [[ -z "$ZK_SECURITY_DIGEST_AUTH_SUPER" ]]; then
      echo "DigestAuthenticationProvider.superDigest=$ZK_SECURITY_DIGEST_AUTH_SUPER"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
    fi
    if ! [[ -z "$ZK_SECURITY_X509_SSL_SUPER_USER" ]]; then
      echo "X509AuthenticationProvider.superUser=$ZK_SECURITY_X509_SSL_SUPER_USER"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
    fi
    if ! [[ -z "$ZK_SECURITY_SSL_KEYSTORE_PASSWORD" ]]; then
      echo "ssl.keyStore.location=$ZOOKEEPER_SSL_FOLDER"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
      echo "ssl.keyStore.password=$ZK_SECURITY_SSL_KEYSTORE_PASSWORD"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
    fi
    if ! [[ -z "$ZK_SECURITY_SSL_TRUSTSTORE_PASSWORD" ]]; then
      echo "ssl.trustStore.location=$ZOOKEEPER_SSL_FOLDER"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
      echo "ssl.trustStore.password=$ZK_SECURITY_SSL_TRUSTSTORE_PASSWORD"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
    fi
    if ! [[ -z "$ZK_SECURITY_SSL_AUTH_PROVIDER" ]]; then
      echo "ssl.authProvider=$ZK_SECURITY_SSL_AUTH_PROVIDER"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
    fi
  fi
  if [[ "true" != "$ZK_UNSAFE_FORCE_SYNC" ]]; then
    export ZK_UNSAFE_FORCE_SYNC="false"
  fi
  echo "forceSync=$ZK_UNSAFE_FORCE_SYNC"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  if ! [[ -z "$ZK_UNSAFE_JUTE_MAX_BUFFER" ]]; then
    echo "jute.maxbuffer=$ZK_UNSAFE_JUTE_MAX_BUFFER"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  if [[ "true" != "$ZK_UNSAFE_SKIP_ACL" ]]; then
    export ZK_UNSAFE_SKIP_ACL="false"
  fi
  echo "skipACL=$ZK_UNSAFE_SKIP_ACL"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  if [[ "true" != "$ZK_UNSAFE_QUORUN_LIST_ALL_IPS" ]]; then
    export ZK_UNSAFE_QUORUN_LIST_ALL_IPS="false"
  fi
  echo "quorumListenOnAllIPs=$ZK_UNSAFE_QUORUN_LIST_ALL_IPS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  if ! [[ -a "$ZK_PERFORMANCE_NUM_SELECTOR_THREADS" ]]; then
    echo "zookeeper.nio.numSelectorThreads=$ZK_PERFORMANCE_NUM_SELECTOR_THREADS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  if ! [[ -a "$ZK_PERFORMANCE_NUM_WORKER_THREADS" ]]; then
    echo "zookeeper.nio.numWorkerThreads=$ZK_PERFORMANCE_NUM_WORKER_THREADS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  if ! [[ -a "$ZK_PERFORMANCE_NUM_COMMIT_WORKER_THREADS" ]]; then
    echo "zookeeper.commitProcessor.numWorkerThreads=$ZK_PERFORMANCE_NUM_COMMIT_WORKER_THREADS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  fi
  echo "znode.container.checkIntervalMs=$ZK_TUNING_CHECK_INTERVAL_MILLIS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  echo "znode.container.maxPerMinute=$ZK_TUNING_CONTAINER_PER_MINUTE"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  echo "admin.enableServer=$ZK_ADMIN_SERVER_ENABLED"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  echo "admin.serverAddress=$ZK_ADMIN_SERVER_ADDRESS"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  echo "admin.serverPort=$ZK_ADMIN_SERVER_PORT"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  echo "admin.idleTimeout=$ZK_ADMIN_SERVER_IDLE_TIMEOUT"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
  echo "admin.commandURL=$ZK_ADMIN_SERVER_COMMAND_URL"  >>  $ZOOKEEPER_HOME/conf/zoo.cfg
fi
sed -i 's/.*=$/#&/g' $ZOOKEEPER_HOME/conf/zoo.cfg
