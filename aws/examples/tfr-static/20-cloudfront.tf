resource "aws_cloudfront_origin_access_control" "default" {
  name                              = var.bucket_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "registry" {
  count = var.use_cloudfront_function ? 1 : 0

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
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
    viewer_protocol_policy = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.use_cloudfront_function ? [1] : []

      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.registry[0].arn
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.use_cloudfront_function ? [] : [1]

    content {
      path_pattern           = "*/download"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = local.s3_origin_id
      viewer_protocol_policy = "redirect-to-https"
      compress               = true
      cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id

      response_headers_policy_id = aws_cloudfront_response_headers_policy.terraform_registry[0].id
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

resource "aws_cloudfront_response_headers_policy" "terraform_registry" {
  count = var.use_cloudfront_function ? 0 : 1

  name = "terraform-registry-download-header"

  comment = "Adds the X-Terraform-Get header with the relative path to the module's archive."

  custom_headers_config {
    items {
      header   = "X-Terraform-Get"
      value    = "./module.tar.gz"
      override = true
    }
  }
}
