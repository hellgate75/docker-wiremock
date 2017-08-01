# --- WIREMOCK ---

FROM ubuntu:16.04

MAINTAINER Fabrizio Torelli <hellgate75@gmail.com>

ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
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
    WM_LOCAL_RESPONSE_TEMPLATING=no



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

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY docker-start-wiremock.sh /docker-start-wiremock.sh
COPY start-wiremock-server.sh /usr/local/bin/start-wiremock-server
COPY stop-wiremock-server.sh /usr/local/bin/stop-wiremock-server
COPY status-wiremock-server.sh /usr/local/bin/status-wiremock-server
COPY head-wiremock.sh /usr/local/bin/head-wiremock
RUN chmod 777 /docker-start-wiremock.sh \
    && chmod 777 /docker-entrypoint.sh \
    && chmod 777 /usr/local/bin/*-wiremock*

VOLUME ["/wiremock/mappings", "/wiremock/__files", "/wiremock/certificates"]

CMD /docker-start-wiremock.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080 443
