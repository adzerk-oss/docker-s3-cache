#!/bin/bash

VARNISH_BACKEND_PORT=${VARNISH_BACKEND_PORT-80}
VARNISH_BACKEND_ELB=${VARNISH_BACKEND_ELB-example.com}
VARNISH_BACKEND_HOST=${VARNISH_BACKEND_HOST-example.com}
VARNISH_BACKEND_FORCE_SSL=${VARNISH_BACKEND_FORCE_SSL-false}
VARNISH_BACKEND_FORCE_SSL_HOST=${VARNISH_BACKEND_FORCE_SSL_HOST-example.com}

function replace_env() {
  local file="${1?}"
  shift
  cp "${file}.in" "$file"
  for name in "$@"; do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" "$file"
  done
}

replace_env /etc/nginx/nginx.conf \
            VARNISH_BACKEND_PORT \
            VARNISH_BACKEND_ELB \
            VARNISH_BACKEND_HOST \
            VARNISH_BACKEND_FORCE_SSL \
            VARNISH_BACKEND_FORCE_SSL_HOST

if [ -n "$DATADOG_API_KEY" ]; then
  replace_env /etc/dd-agent/datadog.conf DATADOG_API_KEY DATADOG_TAGS
  /etc/init.d/datadog-agent start
fi

/etc/init.d/nginx start
varnishd -F -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:${VARNISH_PORT}
