# vim: ft=sh

FROM jacksoncage/varnish
MAINTAINER Micha Niskin <micha@adzerk.com>

ENV VARNISH_PORT 80
ENV VARNISH_BACKEND_PORT 80
ENV VARNISH_BACKEND_IP example.com
ENV VARNISH_BACKEND_HOST example.com

RUN sh -c "echo 'deb http://apt.datadoghq.com/ stable main' > /etc/apt/sources.list.d/datadog.list"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7A7DA52
RUN apt-get update
RUN apt-get install datadog-agent

ADD datadog.conf /etc/dd-agent/datadog.conf
ADD varnish.yaml /etc/dd-agent/conf.d/varnish.yaml
ADD default.vcl /etc/varnish/default.vcl
ADD start.sh /start.sh

EXPOSE 80
ENTRYPOINT ["/start.sh"]
