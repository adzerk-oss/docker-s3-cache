# vim: ft=sh

FROM jacksoncage/varnish
MAINTAINER Micha Niskin <micha@adzerk.com>

ENV VARNISH_PORT 80
ENV VARNISH_BACKEND_PORT 80
ENV VARNISH_BACKEND_IP example.com
ENV VARNISH_BACKEND_HOST example.com

ADD default.vcl /etc/varnish/default.vcl
ADD start.sh /start.sh

EXPOSE 80
ENTRYPOINT ["/start.sh"]
