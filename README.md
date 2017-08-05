<p align="center"><img src="https://github.com/hellgate75/docker-wiremock/raw/master/images/wiremock-logo.png" width="241"  height="110" /> &nbsp;&nbsp;<img src="https://github.com/hellgate75/docker-wiremock/raw/master/images/zookeper-logo.png" width="64"  height="110" /></p>

## Docker Image for Wiremock™ Server

This Docker Image prepare to run a Wiremock™ Server, useful to develop contract between UI and service layers


## Mock your APIs for fast, robust and comprehensive testing

WireMock™ is a simulator for HTTP-based APIs. Some might consider it a service virtualization tool or a mock server.

It enables you to stay productive when an API you depend on doesn't exist or isn't complete. It supports testing of edge cases and failure modes that the real API won't reliably produce. And because it's fast it can reduce your build time from hours down to minutes.


### Goals

Project aims are :
* Define Wiremock™ Server resilient and lightweight docker container
* Define auto-configurable Wiremock™ Server docker container
* Define Apache™ Zookeper integration, to allow remote REST mocking configuration management
* Define mappings and static content auto-download manager for docker container
* Define a wide-usable Development Integration docker container, that is capable to interact with CI tools, Artifact repositories, and other platform components
* Define a SAFE process-ready testing, contracting and validating swiss-knife toolset

*Caution* : No warranties are extended to production or business use of this container, and we are not responsible for illegal or inappropriate use of this project outcomes or any damage on business or digital crime, derived for third-parties actions.


### Our Philosophy

`Try it. Determine business value, derived from product features. Then you consider to buy a license and/or implement a production-ready docker image, accordingly to Product Provider trading or commercial rules.`

*Assumptions* : All our docker images are continuous delivery process ready, and all of them have been tested on `Kubernetes`, `MESOS`, `Portainer.IO`, `Rancher` and `Spinnaker` delivery frameworks, before we released on Docker Hub.


### About WireMock™

Here a list of WireMock™ related pages :

* [Homepage](http://wiremock.org/)

* [Getting Started](http://wiremock.org/docs/getting-started/)


### WireMock™ Server configuration

WireMock™ Server has been provisioned of Apache™ Zookeper system, since now named Configuration Management framework.


#### How does Apache™ Zookeper integration work?

Any of docker image containers accept any configuration environment variable declared in Apache™ Zookeper Docker Image, available on Docker Hub registry : [Docker Hub registry hellgate75/zookeeper](https://hub.docker.com/r/hellgate75/zookeeper/), related to GitHub project repository : [GitHub repository hellgate75/zookeeper](https://github.com/hellgate75/zookeeper).

Additionaly we have provided following configuration environment variable :

* `WIREMOCK_ZOOKEEPER_INTEGRATION_SCRIPT_URL` : Remote bash script Url, cotaining environment variables, downloaded and executed before container start-up (default: )
* `ZOOKEEPER_CLIENT_SERVICE` : [yes/no] Execute Apache™ Zookeper Client Service on container start-up (default: no)
* `ZOOKEEPER_SERVER_SERVICE` : [yes/no] Execute Apache™ Zookeper Server Service on container start-up, if Apache™ Zookeper Client Service is enabled (default: no)
* `ZOOKEEPER_SERVER_ADDRESS` : Remote/Local zookeeper address/port for client configuration operations [e.g.: my-server:2181] (default: "localhost:2181")
* `WIREMOCK_SERVICE_PATH` : Full Apache™ Zookeper WireMock™ service configuration base path (default: )
* `WIREMOCK_ARTIFACT_URL_ENTRY` : Remote Apache™ Zookeper WireMock™ remote mappings artifact tar gz archive Url entry (default: )
* `WIREMOCK_STATIC_URL_ENTRY` : Remote Apache™ Zookeper WireMock™ remote mappings artifact tar gz archive Url entry (default: )
* `WIREMOCK_ZOOKEEPER_SSL_CERTS_URL_ENTRY` : Remote Apache™ Zookeper WireMock™ remote SSL certficate tar gz archive Url entry (default: )
* `ZOOKEEPER_SERVER_CONFIG_URL_ENTRY` : Remote Apache™ Zookeper WireMock™ remote configuration file (e.g.: zoo.cfg) Url entry (default: )
* `ZOOKEEPER_SERVER_CONFIG_SCRIPT_URL_ENTRY` : Remote Apache™ Zookeper WireMock™ remote shell script file (e.g: bootstrap-zookeeper.sh) Url entry (default: )
* `ZOOKEEPER_SEEK_INTERVAL_MIN` : [minutes in hour] Comma separated list of minutes in hour before system seek again for changes in local/remote Apache™ Zookeper Server entries and updating local mappings, static files, certificates, service config and script batches if present in Apache™ Zookeper configuration (default: 15)
* `ZOOKEEPER_SEEK_INTERVAL_HOUR` : [hour in a day] Comma separated list of hours in a day before system seek again for changes in local/remote Apache™ Zookeper Server entries and updating local mappings, static files, certificates, service config and script batches if present in Apache™ Zookeper configuration (default: "" <any>)
* `ZOOKEEPER_SERVER_HOST` : Apache™ Zookeper Server hostaname/ip address (default: localhost)
* `ZOOKEEPER_SERVER_PORT` : Apache™ Zookeper Server hostaname/ip client port (default: 2181)
* `LOG_ON_ZOOKEEPER` : [yes/no] Save on Apache™ Zookeper timestamp of last access (default: no)
* `ZOOKEEPER_LOG_INTERVAL_MIN` : [minutes in hour] Comma separated list of minutes in hour before a new Zookeeper log is lauched (default: 15)
* `ZOOKEEPER_LOG_INTERVAL_HOUR` : [hour in a day] Comma separated list of hours in a day before a new Zookeeper log is lauched (default: "" <any>)
* `CURRENT_SERVER_PATH` : Apache™ Zookeper path (/unique_id/my_path../key...) where store docker container data [timestamp, name, ipaddress, etc...] (default: )
* `CURRENT_SERVER_ID` : Apache™ Zookeper unique server identifier (default: )

Now we explain what service path and any entry combination does mean. We give as assumption that `WIREMOCK_SERVICE_PATH` is equals to `my-wiremock` and `WIREMOCK_ARTIFACT_URL_ENTRY` is equals to `my-mappings`, we expect in Apache™ Zookeper Server, at least one value for WireMock™ Mappings tar gz artifact remote Url, stored in zookeeper path `my-wiremock/my-mappings`. On start-up, if Apache™ Zookeper Client is enabled, docker container will download automatically artifact from url saved on Apache™ Zookeper `my-wiremock/my-mappings` path, updating and refreshing mapping files and context every `ZOOKEEPER_SEEK_INTERVAL` seconds. Same procedure, if related variable are not empty, will be applied for : Apache™ Zookeper static files, Apache™ Zookeper SSL certificates, Apache™ Zookeper configuration file, Apache™ Zookeper environment configuration variables shell script.


### Docker Environment

Docker container exposes following ports:

* `8080`:
Wiremock™ Server HTTP port

* `443`:
Wiremock™ Server HTTPS port

* `8081`:
Apache™ Zookeper Commands REST interface port

* `2181`:
Apache™ Zookeper no-SSL port

* `2182`:

Apache™ Zookeper SSL port


Docker container exposes following volumes:

* `/wiremock/mappings`:

Folder containing mapping files

* `/wiremock/__files`:

Folder containing static files

* `/wiremock/certificates`:

Folder containing SSL certificate files

* `/var/lib/zookeeper` :

Zookeeper Data folder.

* `/var/lib/zookeeper-logs` :

Zookeeper transaction logs folder.

* `/var/lib/zookeeper-ssl`:

Zookeeper ssl certificates and related files (related to keystore and truststore).


Docker container defines following environment variables:

*Infrastructure configuration*:

* `WM_CONFIGURATION_SCRIPT_URL`: Url to Ubuntu bash script, defining variables and base actions, executed before Wiremock™ Server start up (default : )
* `WM_CERTIFICATE_TAR_GZ_URL`: Url to tar gz format file, containing SSL certificate files, installed in the system before Wiremock™ Server start up (default : )
* `WM_MAPPINGS_TAR_GZ_URL`: Url to tar gz format file, containing mapping files, installed in the system before Wiremock™ Server start up (default : )
* `WM_STATIC_FILES_TAR_GZ_URL`: Url to tar gz format file, containing static files, installed in the system before Wiremock™ Server start up (default : )

*Fine grained settings*:

* `WM_HTTP_PORT`: Set the HTTP protocol port number (default : 8080)
* `WM_HTTPS_PORT`: Set the HTTPS protocol port number (default : 443)
* `WM_USE_SSL`: [yes/no] Defines to prefer use of SSL over simple HTTP protocol (default : no)
* `VM_VERBOSE`: [yes/no] Turn on verbose logging (default : yes)
* `WM_BINDING_ADDRESS`: The IP address the WireMock server should serve from. Binds to all local network adapters if unspecified (default : "0.0.0.0")
* `VM_EXTENSIONS`: Extension class names e.g. com.mycorp.HeaderTransformer,com.mycorp.BodyTransformer. See [extending-wiremock](http://wiremock.org/docs/extending-wiremock/) (default : )
* `WM_HTTPS_KEYSTORE`: Path to a keystore file containing an SSL certificate to use with HTTPS. The keystore must have a password of “password”. This option will only work if Wiremock™ Server SSL protocol is enabled. If this option isn’t used WireMock will default to its own self-signed certificate (default : )
* `WM_HTTPS_KS_PASSWORD`: Password to the keystore, if something other than “password” (default : )
* `WM_HTTPS_TRUSTSTORE`: Path to a keystore file containing client certificates. See https and proxy-client-certs for details (default : )
* `WM_HTTPS_TS_PASSWORD`: Optional password to the trust store. Defaults to “password” if not specified (default : )
* `WM_FORCE_REQUIRE_CLIENT_CERT`: [yes/no] Force clients to authenticate with a client certificate. See [https](http://wiremock.org/docs/https/) for details (default : no)
* `WM_RECORD_MAPPING`: [yes/no] Record incoming requests as stub mappings. See [record-playback](http://wiremock.org/docs/record-playback/) and [record-playback-legacy](http://wiremock.org/docs/record-playback-legacy/)  (default : no)
* `VM_MATCH_HEADERS`: [yes/no] When in record mode, capture request headers with the keys specified. See [record-playback](http://wiremock.org/docs/record-playback/) (default : no)
* `VM_PROXY_ALL`: Proxy all requests through to another base URL e.g. "http://api.someservice.com" Typically used in conjunction with `WM_RECORD_MAPPING` on `yes` such that a session on another service can be recorded. (default : )
* `VM_PRESERVE_POST_HEADER`: When in proxy mode, it passes the Host header as it comes from the client through to the proxied service. When this option is not present, the Host header value is deducted from the proxy URL. This option is only available if the `VM_PROXY_ALL` option is specified [yes/no] (default : no)
* `VM_PROXY_VIA`: When proxying requests (either by using `VM_PROXY_ALL` or by creating stub mappings that proxy to other hosts), route via another proxy server (useful when inside a corporate network that only permits internet access via an opaque proxy). e.g. "webproxy.mycorp.com" (defaults to port 80) or "webproxy.mycorp.com:8080" (default : )
* `WM_ENABLE_BROWSER_PROXY`: [yes/no] Run as a browser proxy. See [browser-proxying](http://wiremock.org/docs/proxying/) (default : no)
* `WM_DISABLE_REQUEST_JOURNAL`: [yes/no] Disable the request journal, which records incoming requests for later verification. This allows WireMock to be run (and serve stubs) for long periods (without resetting) without exhausting the heap. The `WM_RECORD_MAPPING` option isn’t available if this one is specified (default : no)
* `WM_CONTAINER_THREADS`: [yes/no] The number of threads created for incoming requests (default : 10)
* `WM_MAX_REQUESTS_JOURNAL_ENTRIES`: Set maximum number of entries in request journal (if enabled). When this limit is reached oldest entries will be discarded (default : )
* `WM_JETTY_REQUEST_THREADS`: The number of threads Jetty uses for accepting requests (default : )
* `WM_JETTY_QUEUE_SIZE`: The Jetty queue size for accepted requests (default : )
* `WM_JETTY_HEADER_BUFFER_SIZE_KB`: The Jetty buffer size (in kilobytes) for request headers, e.g. "16384" (default : 8192)
* `WM_PRINT_ALL_NETWORK_TRAFFIC`: [yes/no] Print all raw incoming and outgoing network traffic (default : no)
* `WM_GLOBAL_RESPONSE_TEMPLATING`: [yes/no] Render all response definitions using Handlebars template (default : no)
* `WM_LOCAL_RESPONSE_TEMPLATING`: [yes/no] Enable rendering of response definitions using Handlebars templates for specific stub mappings (default : no)


### Configuration samples

Here some samples :

* Static HTML homepage file [index.html](https://github.com/hellgate75/docker-wiremock/tree/master/files/index.html)
* Remote Apache™ ZooKeeper Configuration file :  [zookeeper-standalone.cfg](https://github.com/hellgate75/docker-wiremock/tree/master/samples/zookeeper-standalone.cfg)
* Remote Apache™ ZooKeeper Configuration bash script :  [autoconfig-zookeeper-client.sh](https://github.com/hellgate75/docker-wiremock/tree/master/samples/autoconfig-zookeeper-client.sh)
* Remote Apache™ ZooKeeper Docker-Compose Configuration bash script :  [autoconfig-zookeeper-compose.sh](https://github.com/hellgate75/docker-wiremock/tree/master/samples/autoconfig-zookeeper-compose.sh)
* Remote Apache™ ZooKeeper Wiremock™ sample [docker compose](https://github.com/hellgate75/docker-wiremock/tree/master/samples/docker-compose.yml)
* Zookeeper Configuration [sample data](https://github.com/hellgate75/docker-wiremock/tree/master/zookeeper/sample-data)


### Expensions

This docker image extends following docker images :

* Apache™ ZooKeeper Docker Image [Git Hub](https://github.com/hellgate75/zookeeper), [Docker Hub](https://hub.docker.com/r/hellgate75/zookeeper)

Almost all properties, configuration environment variables and functions have been migrated to current docker image. If you want know more about available features, please, take a look to dependant projects.


### Build Docker image

In order to build this docker image, in project root, you can use following command :

```bash
docker build --rm --force-rm --tag wiremock-server:2.7.1 .
```

Or you can simply dowload the Docker hub built one, using following command :

```bash
docker pull hellgate75/wiremock-server:2.7.1
```


### Execute Docker image

In order to execute this docker image, after you have built the image, you can use following command :

```bash
docker run -d --name wiremock-server-2.7.1 -p 8080:8080 -v your-path-to-mappings:/wiremock/mappings -v your-path-to-files:/wiremock/__files \
          -v your-path-to-certificates:/wiremock/certificates  wiremock-server:2.7.1 .
```

In order to execute Docker Hub image, without any prior docker build, you can use following command :

```bash
docker run -d --name wiremock-server-2.7.1 -p 8080:8080 -v your-path-to-mappings:/wiremock/mappings -v your-path-to-files:/wiremock/__files \
          -v your-path-to-certificates:/wiremock/certificates hellgate75/wiremock-server:2.7.1 .
```


### Access Docker container features

In order to access docker container shell, after container ran, you can use following command :

```bash
docker exec -it wiremock-server-2.7.1 bash
```

When you login to container you will display service health information and console access urls


In access to Wiremock™ Server [index.html](https://github.com/hellgate75/docker-wiremock/tree/master/files/index.html) in file folder you can type on your browser following address:

```bash
http://[ container-ip or localhost ]:8080/

or

http://[ container-ip or localhost ]:443/
```

You can test APIs calling Web Methods from base http root, reported in previous example.


### Test Docker Image features

This docker image can work as stand-alone Wiremock server or sharing responsabilities with other ones. Zookeeper integration can work in client, client-server or client-server-replication mode (see [Apache™ ZooKeeper Docker Image project](https://github.com/hellgate75/zookeeper) for more information).

* Sample [docker compose](https://github.com/hellgate75/docker-wiremock/tree/master/samples/docker-compose.yml) : This compose spin up a Wiremock™ Server with Apache™ ZooKeeper client integration and a master Apache™ ZooKeeper Server, connected one each other, and auto-loading configuration from remote repository files. Apache™ ZooKeeper Client System updates continuously configuration and any Wiremock™ Server features, loading configuration from Apache™ ZooKeeper Server, seekeing for changes and applying diff of configuration on any configuration version change.

Testing application you can load defaut http page as reported in `Access Docker container features` README section.


### Docker container logging

Current Docker image logging is available at :

* Wiremock™ Server log file : /var/log/wiremock/server.log
* Apache™ ZooKeeper log folder : /usr/lib/zookeeper/logs
* Apache™ ZooKeeper Client Config log file : /var/log/zookeeper/seek-config-client.log
* Apache™ ZooKeeper Logging Client log file : /var/log/zookeeper/logging-client.log


### Issues

Please report any issue on project Issue Tracker at :

[docker-wiremock Issue Tracker](https://github.com/hellgate75/docker-wiremock/issues)


### LICENSE

[LGPL v.3](https://github.com/hellgate75/docker-wiremock/tree/master/LICENSE)
