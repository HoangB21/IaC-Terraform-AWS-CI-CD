resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = var.comment
  default_root_object = var.default_root_object

  # Origin definitions
  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id

      dynamic "custom_origin_config" {
        for_each = origin.value.type == "custom" ? [1] : []
        content {
          http_port              = origin.value.http_port
          https_port             = origin.value.https_port
          origin_protocol_policy = origin.value.origin_protocol_policy
          origin_ssl_protocols   = origin.value.origin_ssl_protocols
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.type == "s3" ? [1] : []
        content {
          origin_access_identity = ""
        }
      }
      origin_access_control_id = origin.value.origin_access_control_id
    }
  }

  # Default cache behavior
  default_cache_behavior {
    target_origin_id       = var.default_behavior.target_origin_id
    viewer_protocol_policy = var.default_behavior.viewer_protocol_policy
    allowed_methods        = var.default_behavior.allowed_methods
    cached_methods         = var.default_behavior.cached_methods

    forwarded_values {
      query_string = var.default_behavior.forward_query_string
      cookies {
        forward = var.default_behavior.forward_cookies
      }
    }

    min_ttl     = var.default_behavior.min_ttl
    default_ttl = var.default_behavior.default_ttl
    max_ttl     = var.default_behavior.max_ttl
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  # Additional behaviors (optional)
  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods

      dynamic "forwarded_values" {
        for_each = ordered_cache_behavior.value.forward_query_string != null && ordered_cache_behavior.value.forward_cookies != null ? [1] : []
        content {
          query_string = ordered_cache_behavior.value.forward_query_string
          cookies {
            forward = ordered_cache_behavior.value.forward_cookies
          }
        }
      }
      cache_policy_id          = ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id = ordered_cache_behavior.value.origin_request_policy_id
      min_ttl                  = ordered_cache_behavior.value.min_ttl
      default_ttl              = ordered_cache_behavior.value.default_ttl
      max_ttl                  = ordered_cache_behavior.value.max_ttl
    }
  }

  # Viewer certificate (use the default CloudFront SSL)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = var.price_class

  tags = var.tags
}
