# docker-s3-cache

Docker image with Varnish cache for use in Elastic Beanstalk &mdash; caching
for sites deployed to S3.

* Ready to deploy to Elastic Beanstalk.
* Caches requests to websites deployed to S3.
* Alters 302 (Moved Temporarily) responses from S3 to 301's (Moved Permanently).

## Build & Test

To build the image and run it locally for testing:

    $ make build ; make run

## Configure

The image configures itself via environment variables:

* `VARNISH_BACKEND_IP` &mdash; the hostname or IP address of the backend server
  (this will be something like `example.com.s3-website-us-east-1.amazonaws.com`).
* `VARNISH_BACKEND_HOST` &mdash; the desired hostname to be sent to the backend
  as the `Host` header of every request (this will be something like `example.com`).
* `VARNISH_BACKEND_PORT` &mdash; the port the backend is listening on (optional,
  defaults to 80).

These env variables can be set in the Beanstalk environment configuration.

## Deploy to Beanstalk

I use the [eb tool] for this. Everything you need should be in this repository
already.

    $ eb init
    $ eb create <my-env>
    $ eb use <my-env>
    $ eb deploy

Have fun!

[eb tool]: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html
