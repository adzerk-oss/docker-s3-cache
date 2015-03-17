#!/bin/bash

function replace_env() {
  local file="${1?}"
  shift
  cp "${file}.in" "$file"
  for name in "$@"; do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" "$file"
  done
}

function public_ip() {
  ip addr |grep -A2 'state UP' |tail -1 |awk '{print $2}' |cut -d/ -f1
}

replace_env /etc/varnish/default.vcl VARNISH_BACKEND_PORT VARNISH_BACKEND_IP VARNISH_BACKEND_HOST

if [ -n "$DATADOG_API_KEY" ]; then
  replace_env /etc/dd-agent/datadog.conf DATADOG_API_KEY DATADOG_TAGS
  /etc/init.d/datadog-agent start
fi

varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:${VARNISH_PORT}

[ -z "$(public_ip)" ] && sleep 1

echo "********************************************************************************"
echo TEST URL:
echo http://$(public_ip)/
echo "********************************************************************************"

/bin/bash
