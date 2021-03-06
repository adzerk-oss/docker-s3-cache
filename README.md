# docker-s3-cache

[Docker image][dockerhub] with Varnish cache for use in Elastic Beanstalk &mdash;
caching for sites deployed to S3.

* Ready to deploy to Elastic Beanstalk.
* Caches requests to websites deployed to S3.
* Alters 302 (Moved Temporarily) responses from S3 to 301's (Moved Permanently).
* Optional [datadog](http://datadoghq.com) reporting (see below).

## Try It

```
docker run \
  --env VARNISH_BACKEND_HOST=example.com \
  --env VARNISH_BACKEND_ELB=example.com.s3-website-us-east-1.amazonaws.com \
  adzerk/s3-cache
```

## Overview

This container provides three main components:

* The Varnish caching HTTP proxy configured to listen on port 80 and pass HTTP
  requests to localhost port 8080. Any `302` status response is changed to a
  `301` status before being sent to the client.

* An Nginx reverse proxy configured to listen on localhost port 8080 and pass
  HTTP requests to an S3 website hosting bucket ELB. Nginx is needed to resolve
  the ELB's IP address at runtime (Varnish can't do this).

* The DataDog agent daemon for container metrics.

## Runtime Configuration

The image configures itself via environment variables:

| Environment Variable             | Description                                                                                           |
|----------------------------------|-------------------------------------------------------------------------------------------------------|
| `VARNISH_BACKEND_ELB`            | The hostname of the S3 ELB (e.g. `example.com.s3-website-us-east-1.amazonaws.com`).                   |
| `VARNISH_BACKEND_HOST`           | The hostname to be sent to the backend as the `Host` header (e.g. `example.com`).                     |
| `VARNISH_BACKEND_PORT`           | The port the backend will listening on (optional, defaults to 80).                                    |
| `VARNISH_BACKEND_FORCE_SSL`      | When set to "true", rewrite requests to SSL                                                           |
| `VARNISH_BACKEND_FORCE_SSL_HOST` | For use with VARNISH_BACKEND_FORCE_SSL. https host to redirect to.                                    |
| `DATADOG_API_KEY`                | Your [datadog](http://datadoghq.com) API key (datadog agent won't be started if this isn't provided). |
| `DATADOG_TAGS`                   | An optional, comma-delimited list of tags for datadog.                                                |

These env variables can be set in the Beanstalk environment configuration.

## Build & Test Locally

Then build the image:

    make build

Create a `docker.env` file for testing (loaded via the `--env-file` option
to docker), e.g.

    VARNISH_BACKEND_HOST=example.com
    VARNISH_BACKEND_ELB=example.com.s3-website-us-east-1.amazonaws.com
    ...

and start the container:

    make run

## Deploy to Beanstalk

You just need a `Dockerrun.aws.json` file with the following contents:

    {
      "AWSEBDockerrunVersion": "1",
      "Image": {
        "Name": "adzerk/s3-cache",
        "Update": "true"
      },
      "Ports": [
        {
          "ContainerPort": "80"
        }
      ],
      "Volumes": [],
      "Logging": "/var/log/nginx"
    }

[dockerhub]: https://registry.hub.docker.com/u/adzerk/s3-cache/
