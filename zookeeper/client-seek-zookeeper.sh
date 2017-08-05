#!/bin/bash

function system_log() {
  mkdir -p /var/log/zookeeper
  echo "[$(date)] $1" >> /var/log/zookeeper/seek-config-client.log
}

function download_file() {
  if [[ -z "$(echo $2|grep -i 'https://')" ]]; then
    curl -L -o $1 $2
    return "$?"
  else
    curl -sSL -o $1 $2
    return "$?"
  fi
}


system_log "Zookepeer Configuration Client running ..."
ENABLED="$(get-node-zookeeper /$WIREMOCK_SERVICE_PATH $ZOOKEEPER_SERVER_ADDRESS)"

if [[ "enabled" == "$ENABLED" ]]; then
  echo "Remote Wiremock Server Configuration enabled ..."
  echo "Recovering configuration from Apache Zookeeper Server : $ZOOKEEPER_SERVER_ADDRESS"
  VERSION="$(get-node-zookeeper /$WIREMOCK_SERVICE_PATH/version $ZOOKEEPER_SERVER_ADDRESS)"
  echo "Remote Version : $VERSION"
  if ! [[ -z "$VERSION" ]]; then
    touch /root/.zookeeper/config-version
    LOCAL_VERSION="$(cat /root/.zookeeper/config-version)"
    if [[ "$LOCAL_VERSION" != "$VERSION" ]]; then
      touch /root/.zookeeper/config-artifacts
      LOCAL_ARTIFACTS="$(cat /root/.zookeeper/config-artifacts)"
      ARTIFACTS="$(get-node-zookeeper /$WIREMOCK_SERVICE_PATH/$WIREMOCK_ARTIFACT_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
      if [[ "$LOCAL_ARTIFACTS" != "$ARTIFACTS" ]]; then
        echo "Applying new artifacts : mappings archive"
        if ! [[ -z "$ARTIFACTS"  ]]; then
          download_file /root/artifact.tgz $ARTIFACTS
          if [[ "0" == "$?" ]]; then
            tar -xzf /root/artifact.tgz -C /wiremock/mappings
            rm -f /root/artifact.tgz
            #Define procedure to apply artifacts archive
            echo "$ARTIFACTS" > /root/.zookeeper/config-artifacts
          else
            echo "Artifact not correctly downloaded from '$ARTIFACTS' in version : $VERSION"
          fi
        else
          echo "Artifact empty in version : $VERSION"
        fi
      else
        echo "Artifact not changed in version : $VERSION"
      fi
      touch /root/.zookeeper/config-static-files
      LOCAL_STATIC="$(cat /root/.zookeeper/config-static-files)"
      STATIC="$(get-node-zookeeper /$WIREMOCK_SERVICE_PATH/$WIREMOCK_STATIC_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
      if [[ "$LOCAL_STATIC" != "$STATIC" ]]; then
        echo "Applying new static files : static html content"
        if ! [[ -z "$STATIC"  ]]; then
          download_file /root/static-files.tgz $STATIC
          if [[ "0" == "$?" ]]; then
            tar -xzf /root/static-files.tgz -C /wiremock/__files
            rm -f /root/static-files.tgz
            #Define procedure to apply static files
            echo "$STATIC" > /root/.zookeeper/config-static-files
          else
            echo "Static files not correctly downloaded from '$STATIC' in version : $VERSION"
          fi
        else
          echo "Static files empty in version : $VERSION"
        fi
      else
        echo "Static files not changed in version : $VERSION"
      fi
      touch /root/.zookeeper/config-certificates
      LOCAL_SSL_CERTIFICATES="$(cat /root/.zookeeper/config-certificates)"
      SSL_CERTIFICATES="$(get-node-zookeeper /$WIREMOCK_SERVICE_PATH/$WIREMOCK_ZOOKEEPER_SSL_CERTS_URL_ENTRY $ZOOKEEPER_SERVER_ADDRESS)"
      if [[ "$LOCAL_SSL_CERTIFICATES" != "$SSL_CERTIFICATES" ]]; then
        echo "Applying new certificate files : SSL Certificates"
        if ! [[ -z "$SSL_CERTIFICATES"  ]]; then
          download_file /root/certificates.tgz $SSL_CERTIFICATES
          if [[ "0" == "$?" ]]; then
            tar -xzf /root/certificates.tgz -C /wiremock/certificates
            rm -f /root/certificates.tgz
            #Define procedure to apply certificates
            echo "$SSL_CERTIFICATES" > /root/.zookeeper/config-certificates
          else
            echo "Certificates not correctly downloaded from '$SSL_CERTIFICATES' in version : $VERSION"
          fi
        else
          echo "Certificates empty in version : $VERSION"
        fi
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
