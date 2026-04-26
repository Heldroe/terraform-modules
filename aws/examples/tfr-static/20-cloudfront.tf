resource "aws_cloudfront_origin_access_control" "default" {
  name                              = var.bucket_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "registry" {
  name    = var.bucket_name
  runtime = "cloudfront-js-2.0"
  comment = var.description
  publish = true
  code    = file("${path.module}/function/function.js")
}

resource "aws_cloudfront_distribution" "distribution" {
  comment = var.description

  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name              = aws_s3_bucket.static.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  http_version        = "http2and3"
  default_root_object = "index.html"

  web_acl_id = var.acl_arn

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    compress = true

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.registry.arn
    }
  }

  tags = {
    Name = var.description
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
