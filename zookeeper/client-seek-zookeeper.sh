#!/bin/bash

function system_log() {
  mkdir -p /var/log/zookeeper
  echo "[$(date)] $1" >> /var/log/zookeeper/seek-config-client.log
}

system_log "Zookepeer Configuration Client running ..."
ENABLED="$(get-node-zookeepe /$WIREMOCK_SERVICE_PATH $ZOOKEEPER_SERVER_ADDRESS)"

if [[ "enabled" == "$ENABLED" ]]; then
  echo "Remote Wiremock Server Configuration enabled ..."
  echo "Recovering configuration from Apache Zookeeper Server : $ $ZOOKEEPER_SERVER_ADDRESS"
  VERSION="$(get-node-zookeepe /$WIREMOCK_SERVICE_PATH/$WIREMOCK_ARTIFACT_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
  echo "Remote Version : $ $VERSION"
  if ! [[ -z "$VERSION" ]]; then
    touch /root/.zookeeper/config-version
    LOCAL_VERSION="$(cat /root/.zookeeper/config-version)"
    if [[ "$LOCAL_VERSION" != "$VERSiON" ]]; then
      touch /root/.zookeeper/config-artifacts
      LOCAL_ARTIFACTS="$(cat /root/.zookeeper/config-artifacts)"
      ARTIFACTS="$(get-node-zookeepe /$WIREMOCK_SERVICE_PATH/$WIREMOCK_ARTIFACT_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
      if [[ "$LOCAL_ARTIFACTS" != "$ARTIFACTS" ]]; then
        echo "Applying new artifacts : mappings archive"
        #Define procedure to apply artifacts archive
        echo "$ARTIFACTS" > /root/.zookeeper/config-artifacts
      else
        echo "Artifact not changed in version : $VERSION"
      fi
      touch /root/.zookeeper/config-static-files
      LOCAL_STATIC="$(cat /root/.zookeeper/config-static-files)"
      STATIC="$(get-node-zookeepe /$WIREMOCK_SERVICE_PATH/$WIREMOCK_STATIC_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
      if [[ "$LOCAL_STATIC" != "$STATIC" ]]; then
        echo "Applying new static files : static html content"
        #Define procedure to apply static files
        echo "$STATIC" > /root/.zookeeper/config-static-files
      else
        echo "Static files not changed in version : $VERSION"
      fi
      touch /root/.zookeeper/config-certificates
      LOCAL_SSL_CERTIFICATES="$(cat /root/.zookeeper/config-certificates)"
      SSL_CERTIFICATES="$(get-node-zookeepe /$WIREMOCK_SERVICE_PATH/$WIREMOCK_ZOOKEEPER_SSL_CERTS_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
      if [[ "$LOCAL_SSL_CERTIFICATES" != "$SSL_CERTIFICATES" ]]; then
        echo "Applying new certificate files : SSL Certificates"
        #Define procedure to apply certificates
        echo "$SSL_CERTIFICATES" > /root/.zookeeper/config-certificates
      else
        echo "Certificates not changed in version : $VERSION"
      fi
      echo "$VERSION" > /root/.zookeeper/config-version
    else
      echo "Remote Wiremock Server Configuration version not changed ..."
    fi

  else
    echo "Remote Wiremock Server Configuration invalid version: empty"
  fi
else
  echo "Remote Wiremock Server Configuration disabled [value: $ENABLED] ..."
fi
