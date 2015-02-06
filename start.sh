#!/bin/bash

for name in VARNISH_BACKEND_PORT VARNISH_BACKEND_IP VARNISH_BACKEND_HOST; do
  eval value=\$$name
  sed -i "s|\${${name}}|${value}|g" /etc/varnish/default.vcl
done

if [ -n "$DATADOG_API_KEY" ]; then
  for name in DATADOG_API_KEY DATADOG_TAGS; do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/dd-agent/datadog.conf
  done
  /etc/init.d/datadog-agent start
fi

echo "********************************************************************************"
echo TEST URL:
echo http://$(ip addr |grep -A2 'state UP' |tail -1 |awk '{print $2}' |cut -d/ -f1)/
echo "********************************************************************************"

varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:${VARNISH_PORT}
varnishstat -1  && echo -e "\e[0;32mVarnishStat - OK\e[0m" || \ || echo -e "\e[0;31mVarnishStat - ERROR\e[0m"
varnishlog
