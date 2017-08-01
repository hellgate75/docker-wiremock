<p align="center"><img src="https://github.com/hellgate75/docker-wiremock/raw/master/images/wiremock-logo.png" width="241"  height="110" /></p>

## Docker Image for Wiremock™

This Docker Image prepare to run a Wiremock™ Server, useful to develop contract between UI and service layers


## Mock your APIs for fast, robust and comprehensive testing

WireMock™ is a simulator for HTTP-based APIs. Some might consider it a service virtualization tool or a mock server.

It enables you to stay productive when an API you depend on doesn't exist or isn't complete. It supports testing of edge cases and failure modes that the real API won't reliably produce. And because it's fast it can reduce your build time from hours down to minutes.


### Goals

N/A

*Caution* : No warranties are extended to production or business use of this container, and we are not responsible for illegal or inappropriate use of this project outcomes or any damage on business or digital crime, derived for third-parties actions.


### Our Philosophy

`Try it. Determine business value, derived from product features. Then you consider to buy a license and/or implement a production-ready docker image, accordingly to Product Provider trading or commercial rules.`

*Assumptions* : All our docker images are continuous delivery process ready, and all of them have been tested on `Kubernetes`, `MESOS`, `Portainer.IO`, `Rancher` and `Spinnaker` delivery frameworks, before we released on Docker Hub.


### About WireMock™

Here a list of WireMock™ related pages :

* [Homepage](http://wiremock.org/)

* [Getting Started](http://wiremock.org/docs/getting-started/)


### Docker Environment

Docker container exposes following ports:

N/A


Docker container exposes following volumes:

N/A



Docker container defines following environment variables:

N/A


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


In access to Wiremock™ Server index.html in file folder you can type on your browser following address:

```bash
http://[ container-ip or localhost ]:8080/

or

http://[ container-ip or localhost ]:443/
```


### Issues

Please report any issue on project Issue Tracker at :

[docker-wiremock Issue Tracker](https://github.com/hellgate75/docker-wiremock/issues)


### LICENSE

[LGPL v.3](https://github.com/hellgate75/docker-wiremock/tree/master/LICENSE)
