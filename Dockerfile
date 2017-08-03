# --- WIREMOCK ---

FROM ubuntu:16.04

MAINTAINER Fabrizio Torelli <hellgate75@gmail.com>

ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    WIREMOCK_HOME=/wiremock \
    WM_VERSION=2.7.1 \
    WM_DT_VERSION=1.1.6 \
    WM_HTTP_CC_VERSION=5.0-alpha2  \
    DEBIAN_FRONTEND=noninteractive \
    WM_CONFIGURATION_SCRIPT_URL= \
    WM_CERTIFICATE_TAR_GZ_URL= \
    WM_MAPPINGS_TAR_GZ_URL= \
    WM_STATIC_FILES_TAR_GZ_URL= \
    WM_HTTP_PORT=8080 \
    WM_HTTPS_PORT=443 \
    WM_USE_SSL=no \
    VM_VERBOSE=yes \
    WM_BINDING_ADDRESS="0.0.0.0" \
    VM_EXTENSIONS= \
    WM_HTTPS_KEYSTORE= \
    WM_HTTPS_KS_PASSWORD= \
    WM_HTTPS_TRUSTSTORE= \
    WM_HTTPS_TS_PASSWORD= \
    WM_FORCE_REQUIRE_CLIENT_CERT=no \
    WM_RECORD_MAPPING=no \
    VM_MATCH_HEADERS=no \
    VM_PROXY_ALL= \
    VM_PRESERVE_POST_HEADER=no \
    VM_PROXY_VIA= \
    WM_ENABLE_BROWSER_PROXY=no \
    WM_DISABLE_REQUEST_JOURNAL=no \
    WM_CONTAINER_THREADS=10 \
    WM_MAX_REQUESTS_JOURNAL_ENTRIES= \
    WM_JETTY_REQUEST_THREADS= \
    WM_JETTY_QUEUE_SIZE= \
    WM_JETTY_HEADER_BUFFER_SIZE_KB=8192 \
    WM_PRINT_ALL_NETWORK_TRAFFIC=no \
    WM_GLOBAL_RESPONSE_TEMPLATING=no \
    WM_LOCAL_RESPONSE_TEMPLATING=no \
    WIREMOCK_ZOOKEEPER_INTEGRATION_SCRIPT_URL= \
    ZOOKEEPER_CLIENT_SERVICE=no \
    ZOOKEEPER_SERVER_SERVICE=no \
    WIREMOCK_SERVICE_PATH= \
    WIREMOCK_ARTIFACT_URL_ENTRY= \
    WIREMOCK_STATIC_URL_ENTRY= \
    WIREMOCK_ZOOKEEPER_SSL_CERTS_URL_ENTRY= \
    ZOOKEEPER_RELEASE=3.5.3-beta \
    ZOOKEEPER_HOME=/usr/local/zookeeper \
    ZOOKEEPER_PREFIX=/usr/local/zookeeper \
    ZOO_LOG_DIR=/usr/local/zookeeper/logs \
    ZOOKEEPER_DATA_FOLDER=/var/lib/zookeeper \
    ZOOKEEPER_LOGS_FOLDER=/var/lib/zookeeper-logs \
    ZOOKEEPER_SSL_FOLDER=/var/lib/zookeeper-ssl \
    ZK_ADMIN_SERVER_ADDRESS=8181 \
    ZOOKEEPER_SERVER_CONFIG_URL_ENTRY= \
    ZOOKEEPER_SERVER_CONFIG_SCRIPT_URL_ENTRY= \
    ZOOKEEPER_SEEK_INTERVAL=300 \
    ZOOKEEPER_SERVER_HOST=localhost \
    ZOOKEEPER_SERVER_PORT=2181 \
    LOG_ON_ZOOKEEPER=no \
    ZOOKEEPER_LOG_TIMEOUT=300 \
    CURRENT_SERVER_PATH= \
    CURRENT_SERVER_ID= \
    PATH=$PATH:/usr/local/zookeeper/bin



RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install apt-utils \
    && apt-get -y install software-properties-common \
    && apt-get -y install wget curl htop git vim net-tools \
    && add-apt-repository -y -u ppa:webupd8team/java \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && echo -e "\n" | apt-get -y install oracle-java8-installer oracle-java8-set-default \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /wiremock \
    && mkdir /wiremock/mappings \
    && mkdir /wiremock/__files \
    && mkdir /wiremock/certificates

WORKDIR /wiremock

RUN curl -sSL -o wiremock-standalone.jar http://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/$WM_VERSION/wiremock-standalone-$WM_VERSION.jar
RUN curl -sSL -o body-transformer.jar http://central.maven.org/maven2/com/opentable/wiremock-body-transformer/$WM_DT_VERSION/wiremock-body-transformer-$WM_DT_VERSION.jar
RUN curl -sSL -o httpcomponents-client.tar.gz https://archive.apache.org/dist/httpcomponents/httpclient/binary/httpcomponents-client-$WM_HTTP_CC_VERSION-bin.tar.gz
RUN tar -xzf httpcomponents-client.tar.gz

RUN curl -sSL http://www-eu.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_RELEASE/zookeeper-$ZOOKEEPER_RELEASE.tar.gz | tar -x -C /usr/local/ \
    && cd /usr/local && ln -s zookeeper-* zookeeper \
    && mkdir -p $ZOOKEEPER_DATA_FOLDER \
    && mkdir -p ZOOKEEPER_LOGS_FOLDER \
    && mkdir -p $ZOOKEEPER_SSL_FOLDER \
    && mkdir -p $ZOOKEEPER_HOME/conf \
    && mkdir -p $ZOOKEEPER_HOME/logs

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY docker-start-wiremock.sh /docker-start-wiremock.sh
COPY start-wiremock-server.sh /usr/local/bin/start-wiremock-server
COPY stop-wiremock-server.sh /usr/local/bin/stop-wiremock-server
COPY status-wiremock-server.sh /usr/local/bin/status-wiremock-server
COPY head-wiremock.sh /usr/local/bin/head-wiremock

ADD zookeeper/zookeeper.cfg.standalone.template $ZOOKEEPER_HOME/conf/zoo.cfg.standalone.template
ADD zookeeper/zookeeper.cfg.replica.template $ZOOKEEPER_HOME/conf/zoo.cfg.replica.template
COPY zookeeper/start-zookeeper.sh /usr/local/bin/start-zookeeper
COPY zookeeper/status-zookeeper.sh /usr/local/bin/status-zookeeper
COPY zookeeper/stop-zookeeper.sh /usr/local/bin/stop-zookeeper
COPY zookeeper/head-zookeeper.sh /usr/local/bin/head-zookeeper
COPY zookeeper/configure-zookeeper.sh /usr/local/bin/configure-zookeeper

RUN chmod 777 /docker-start-wiremock.sh \
    && chmod 777 /docker-entrypoint.sh \
    && chmod 777 /usr/local/bin/*-wiremock* \
    && chmod +x /usr/local/bin/*zookeeper

VOLUME ["/wiremock/mappings", "/wiremock/__files", "/wiremock/certificates", "/var/lib/zookeeper", "/var/lib/zookeeper-logs", "/var/lib/zookeeper-ssl"]

CMD /docker-start-wiremock.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080 443 8080 2181 2182
