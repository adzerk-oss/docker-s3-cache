# This is a VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
#
vcl 4.0;
backend default {
  .host = "127.0.0.1";
  .port = "8080";
}

sub vcl_backend_response {
  if (beresp.status == 302) {
    set beresp.status = 301;
  }
}
