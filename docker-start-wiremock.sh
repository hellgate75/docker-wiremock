#!/usr/bin/env bash

function download_file() {
  if [[ -z "$(echo $2|grep -i 'https://')" ]]; then
    curl -L -o $1 $2
    return "$?"
  else
    curl -sSL -o $1 $2
    return "$?"
  fi
}

source $(which setenv-zookeeper)

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

source $(which setenv-zookeeper)
source $(which custom-setenv-zookeeper)

if [[ "yes" == "$ZOOKEEPER_CLIENT_SERVICE" ]]; then

  if ! [[ -e /root/.configure-zookeeper-client  ]]; then
    TIME_MM="$ZOOKEEPER_SEEK_INTERVAL_MIN"
    TIME_HH="$ZOOKEEPER_SEEK_INTERVAL_HOUR"
    if [[ -z "$TIME_MM" ]]; then
      TIME_MM="*"
    fi
    if [[ -z "$TIME_HH" ]]; then
      TIME_HH="*"
    fi
    echo "Installing Seeker Job at every MM=$TIME_MM, HH=$TIME_HH"
    set-crontab-job "$TIME_MM" "$TIME_HH" "root" "seek-zookeeper"
    touch /root/.configure-zookeeper-client
  fi
  if [[ "yes" == "$LOG_ON_ZOOKEEPER" ]]; then
    if ! [[ -e /root/.configure-zookeeper-log  ]]; then
      TIME_MM="$ZOOKEEPER_LOG_INTERVAL_MIN"
      TIME_HH="$ZOOKEEPER_LOG_INTERVAL_HOUR"
      if [[ -z "$TIME_MM" ]]; then
        TIME_MM="*"
      fi
      if [[ -z "$TIME_HH" ]]; then
        TIME_HH="*"
      fi
      echo "Installing Logger Job at every MM=$TIME_MM, HH=$TIME_HH"
      set-crontab-job "$TIME_MM" "$TIME_HH" "root" "log-zookeeper"
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

if [[ "yes" == "$ZOOKEEPER_CLIENT_SERVICE" ]]; then
  if [[ "yes" == "$ZOOKEEPER_SERVER_SERVICE" ]]; then
    if [[ -z "$ZOOKERPER_ACTIVE" ]]; then
      echo "Configuring Apache Zookeeper v. $ZOOKEEPER_RELEASE ..."
      start-zookeeper
      sleep 2
      import-data-zookeeper
      head-zookeeper
    fi
  fi
fi

dump-env

service wiremock start

sleep 1

head-wiremock

echo "Logging wiremock ..."
tail -f /var/log/wiremock/server.log

echo "Waiting forever ..."
tail -f /dev/null
