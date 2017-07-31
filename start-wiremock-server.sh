#!/bin/bash

RUNNING="$(ps -eaf|grep java| grep 'wiremock-standalone'|grep -v grep)"

if ! [[ -z "$RUNNING" ]]; then
  echo "Wiremock Srver already running ..."
  exit 0
fi

if ! [[ -z "$WM_CONFIGURATION_SCRIPT_URL" ]]; then
  echo "Downloading Wiremock Server init shell script from URL : $WM_CONFIGURATION_SCRIPT_URL"
  curl -sSL -o /wiremock/environment.sh $WM_CONFIGURATION_SCRIPT_URL
fi

if ! [[ -z "$WM_CERTIFICATE_TAR_GZ_URL" ]]; then
  echo "Downloading Wiremock Server certificates tar gz file from URL : $WM_CERTIFICATE_TAR_GZ_URL"
  curl -sSL -o /wiremock/certificates.tgz $WM_CERTIFICATE_TAR_GZ_URL
  if [[ -e /wiremock/certificates.tgz ]]; then
    echo "Extracting Wiremock Server certificates from file"
    tar -C /wiremock/certificates -xzf certificates.tgz
  else
    echo "Unable to download Wiremock Server certificates from URL : $WM_CERTIFICATE_TAR_GZ_URL"
  fi
fi

if [[ -e /wiremock/certificates ]]; then
  if [[ "" != "$(ls /wiremock/certificates/)" ]]; then
    echo "Copying wiremock certificates ..."
    cp /wiremock/certificates/* /etc/ssl/certificates/
  fi
fi

if [[ -e /wiremock/environment.sh ]]; then
  chmod 777 /wiremock/environment.sh
  . /wiremock/environment.sh
fi

WM_ARGS=""

if [[ "yes" == "$WM_USE_SSL" ]]; then
  WM_ARGS=" --https-port $WM_HTTPS_PORT"

  if [[ "" == "$WM_HTTPS_KEYSTORE" ]]; then
    VM_ARGS="$WM_ARGS --https-keystore $WM_HTTPS_KEYSTORE"
  fi

  if [[ "" == "$WM_HTTPS_KS_PASSWORD" ]]; then
    VM_ARGS="$WM_ARGS --keystore-password $WM_HTTPS_KS_PASSWORD"
  fi

  if [[ "" == "$WM_HTTPS_TRUSTSTORE" ]]; then
    VM_ARGS="$WM_ARGS --https-truststore $WM_HTTPS_TRUSTSTORE"
  fi

  if [[ "" == "$WM_HTTPS_TS_PASSWORD" ]]; then
    VM_ARGS="$WM_ARGS --truststore-password $WM_HTTPS_TS_PASSWORD"
  fi
else
  WM_ARGS=" --port $WM_HTTP_PORT"
fi

if [[ "" == "$WM_BINDING_ADDRESS" ]]; then
  VM_ARGS="$WM_ARGS --bind-address $WM_BINDING_ADDRESS"
fi

if [[ "" == "$VM_EXTENSIONS" ]]; then
  VM_ARGS="$WM_ARGS --extensions com.opentable.extension.BodyTransformer $VM_EXTENSIONS"
else
  VM_ARGS="$WM_ARGS --extensions com.opentable.extension.BodyTransformer"
fi

if [[ "yes" == "$VM_VERBOSE" ]]; then
  VM_ARGS="$WM_ARGS --verbose"
fi

if [[ "yes" == "$WM_FORCE_REQUIRE_CLIENT_CERT" ]]; then
  VM_ARGS="$WM_ARGS --https-require-client-cert"
fi

if [[ "yes" == "$WM_RECORD_MAPPING" ]]; then
  VM_ARGS="$WM_ARGS --record-mappings"
fi

if [[ "yes" == "$VM_MATCH_HEADERS" ]]; then
  VM_ARGS="$WM_ARGS --match-headers"
fi

if [[ "" != "$VM_PROXY_ALL" ]]; then
  VM_ARGS="$WM_ARGS --proxy-all $VM_PROXY_ALL"
  if [[ "yes" == "$VM_PRESERVE_POST_HEADER" ]]; then
    VM_ARGS="$WM_ARGS --preserve-host-header"
  fi
fi

if [[ "" != "$VM_PROXY_VIA" ]]; then
  VM_ARGS="$VM_ARGS --proxy-via $VM_PROXY_VIA"
fi

if [[ "yes" == "$WM_ENABLE_BROWSER_PROXY" ]]; then
  VM_ARGS="$WM_ARGS --enable-browser-proxying"
fi

if [[ "yes" == "$WM_DISABLE_REQUEST_JOURNAL" ]]; then
  VM_ARGS="$WM_ARGS --no-request-journal"
fi

if [[ "" != "$WM_CONTAINER_THREADS" ]]; then
  VM_ARGS="$WM_ARGS --container-threads $WM_CONTAINER_THREADS"
fi

if [[ "" != "$WM_MAX_REQUESTS_JOURNAL_ENTRIES" ]]; then
  VM_ARGS="$WM_ARGS --max-request-journal-entries $WM_MAX_REQUESTS_JOURNAL_ENTRIES"
fi

if [[ "" != "$WM_JETTY_REQUEST_THREADS" ]]; then
  VM_ARGS="$WM_ARGS --jetty-acceptor-threads $WM_JETTY_REQUEST_THREADS"
fi

if [[ "" != "$WM_JETTY_QUEUE_SIZE" ]]; then
  VM_ARGS="$WM_ARGS --jetty-accept-queue-size $WM_JETTY_QUEUE_SIZE"
fi
if [[ "" != "$WM_JETTY_HEADER_BUFFER_SIZE_KB" ]]; then
  VM_ARGS="$WM_ARGS --jetty-header-buffer-size $WM_JETTY_HEADER_BUFFER_SIZE_KB"
fi

if [[ "yes" == "$WM_PRINT_ALL_NETWORK_TRAFFIC" ]]; then
  VM_ARGS="$WM_ARGS --print-all-network-traffic"
fi

if [[ "yes" == "$WM_GLOBAL_RESPONSE_TEMPLATING" ]]; then
  VM_ARGS="$WM_ARGS --global-response-templating"
fi

if [[ "yes" == "$WM_LOCAL_RESPONSE_TEMPLATING" ]]; then
  VM_ARGS="$WM_ARGS --local-response-templating"
fi

VM_ARGS="$VM_ARGS --root-dir /wiremock"

mkdir -p /var/log/wiremock

cd /wiremock

java -cp body-transformer.jar:wiremock-standalone.jar:httpcomponents-client-$WM_HTTP_CC_VERSION/lib/* com.github.tomakehurst.wiremock.standalone.WireMockServerRunner$WM_ARGS >> /var/log/wiremock/server.log

sllep 5
