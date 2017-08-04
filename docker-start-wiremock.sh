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

function set_crontab_task() {
  CRON_MINS="$1"
  CRON_HOUR="$2"
  if [[ "" == "$CRON_MINS" ]]; then
    if [[ -z "$CRON_HOUR" ]]; then
      CRON_MINS=15
    else
      CRON_MINS="*"
    fi
  fi
  if [[ "" == "$CRON_HOUR" ]]; then
    if [[ -z "$CRON_MINS" ]]; then
      CRON_MINS=15
    else
      CRON_HOUR="*"
    fi
  fi
  echo "$CRON_MINS $CRON_HOUR	* * *	$3    $4" >> etc/crontab

}

. setenv-zookeeper

ZOOKERPER_ACTIVE="$(ps -eaf | grep java | grep zookeeper)"

if ! [[ -z "$WIREMOCK_ZOOKEEPER_INTEGRATION_SCRIPT_URL" ]]; then
  echo "Configuring Apache Zookeeper v. $ZOOKEEPER_RELEASE integration in Wiremock Server v. $WM_VERSION via URL : $WIREMOCK_ZOOKEEPER_INTEGRATION_SCRIPT_URL ..."
  download_file /usr/local/bin/custom-setenv-zookeeper $WIREMOCK_ZOOKEEPER_INTEGRATION_SCRIPT_URL
  export URL_EXIT_CODE="$?"
  if [[ "0" == "$URL_EXIT_CODE" ]]; then
    echo "URL integration script recovered succesfully!!"
    chmod 777 /usr/local/bin/custom-setenv-zookeeper
  else
    cp /root/.wiremock/bkp-custom-setenv-zookeeper /usr/local/bin/custom-setenv-zookeeper
    chmod 777 /usr/local/bin/custom-setenv-zookeeper
    echo "Error [$URL_EXIT_CODE] retrieving integration script from URL : $WIREMOCK_ZOOKEEPER_INTEGRATION_SCRIPT_URL"
  fi
fi

. custom-setenv-zookeeper

if [[ "yes" == "$ZOOKEEPER_CLIENT_SERVICE" ]]; then

  if ! [[ -e /root/.configure-zookeeper-client  ]]; then
    set_crontab_task $ZOOKEEPER_SEEK_INTERVAL_MIN $ZOOKEEPER_SEEK_INTERVAL_HOUR "root" "seek-zookeeper"
    touch /root/.configure-zookeeper-client
  fi
  if [[ "yes" == "$LOG_ON_ZOOKEEPER" ]]; then
    if ! [[ -e /root/.configure-zookeeper-log  ]]; then
      set_crontab_task $ZOOKEEPER_LOG_INTERVAL_MIN $ZOOKEEPER_LOG_INTERVAL_HOUR "root" "log-zookeeper"
      touch /root/.configure-zookeeper-log
    fi
  fi

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
