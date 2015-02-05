# This is a VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
#
backend default {
  .host = "${VARNISH_BACKEND_IP}";
  .port = "${VARNISH_BACKEND_PORT}";
}

sub vcl_recv {
  set req.http.host = "${VARNISH_BACKEND_HOST}";
}

sub vcl_fetch {
  if (beresp.status == 302) {
    set beresp.status = 301;
    set beresp.response = "Moved Permanently";
  }
}
