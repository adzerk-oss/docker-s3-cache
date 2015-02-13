# This is a VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
#
backend default {
  .host = "${VARNISH_BACKEND_IP}";
  .port = "${VARNISH_BACKEND_PORT}";
}

sub vcl_recv {
  set req.http.host = "${VARNISH_BACKEND_HOST}";

  if (req.url ~ "^/ad-server-privacy/*$") {
    error 750 "/privacy/ad-server/";
  }
  if (req.url ~ "^/customer-privacy/*$") {
    error 750 "/privacy/customers/";
  }
  if (req.url ~ "^/sales/*$") {
    error 750 "/contact/";
  }
  if (req.url ~ "^/ad-server-jobs/*$") {
    error 750 "/about/";
  }
  if (req.url ~ "^/features/*$") {
    error 750 "/solutions/";
  }
  if (req.url ~ "^/ad-server-resources/*$") {
    error 750 "/";
  }
  if (req.url ~ "^/support/*$") {
    error 750 "/help/";
  }
  if (req.url ~ "^/customers/ad-server-for-publishers/*$") {
    error 750 "/solutions/";
  }
  if (req.url ~ "^/ad-serving-resource-center/*$") {
    error 750 "/";
  }
  if (req.url ~ "^/customers/ad-server-developer-api/*$") {
    error 750 "/solutions/";
  }
  if (req.url ~ "^/blog/2014/10/using-advertisting-to-monetize-a-social-media-community/*$") {
    error 750 "/blog/2014/10/using-advertising-to-monetize-a-social-media-community/";
  }
  if (req.url ~ "^/news-and-announcements/reddit-is-using-adzerk/*$") {
    error 750 "/blog/2013/03/reddit-is-using-adzerk/";
  }
  if (req.url ~ "^/job-openings/*$") {
    error 750 "/about/";
  }
  if (req.url ~ "^/for-publishers/*$") {
    error 750 "/solutions/";
  }
  if (req.url ~ "^/product-blog/the-fastest-ad-code-in-the-world//*$") {
    error 750 "/blog/2012/06/the-fastest-ad-code-in-the-world/";
  }
  if (req.url ~ "^/our-team/*$") {
    error 750 "/about/";
  }
  if (req.url ~ "^/product-tour/*$") {
    error 750 "/learn/";
  }
}

sub vcl_error {
  if (obj.status == 750) {
    set obj.http.Location = obj.response;
    set obj.status = 301;
    return(deliver);
  }
}

sub vcl_fetch {
  if (beresp.status == 302) {
    set beresp.status = 301;
    set beresp.response = "Moved Permanently";
  }
}
