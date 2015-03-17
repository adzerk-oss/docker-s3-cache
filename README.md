# docker-s3-cache

Docker image with Varnish cache for use in Elastic Beanstalk &mdash; caching
for sites deployed to S3.

* Ready to deploy to Elastic Beanstalk.
* Caches requests to websites deployed to S3.
* Alters 302 (Moved Temporarily) responses from S3 to 301's (Moved Permanently).
* Optional [datadog](http://datadoghq.com) reporting (see below).

## Configure

The image configures itself via environment variables:

| Environment Variable   | Description                                                                                               |
|------------------------|-----------------------------------------------------------------------------------------------------------|
| `VARNISH_BACKEND_IP`   | The hostname or IP address of the backend server (e.g. `example.com.s3-website-us-east-1.amazonaws.com`). |
| `VARNISH_BACKEND_HOST` | The hostname to be sent to the backend as the `Host` header (e.g. `example.com`).                         |
| `VARNISH_BACKEND_PORT` | The port the backend will listening on (optional, defaults to 80).                                        |
| `DATADOG_API_KEY`      | Your [datadog](http://datadoghq.com) API key (datadog agent won't be started if this isn't provided).     |
| `DATADOG_TAGS`         | An optional, comma-delimited list of tags.                                                                |

These env variables can be set in the Beanstalk environment configuration or
locally in a `docker.env` file (loaded via the `--env-file` option to docker).

## Build & Test

Then build the image and run it locally:

    $ make build ; make run

You'll see a message like this:

    ********************************************************************************
    TEST URL:
    http://172.17.0.20/
    ********************************************************************************

You can open the test URL in your browser or use `curl(1)` to see the proxy in
action.


## Deploy to Beanstalk

I use the [eb tool] for this. Everything you need should be in this repository
already.

    $ eb init
    $ eb create <my-env>
    $ eb use <my-env>
    $ eb deploy

Have fun!

[eb tool]: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html
