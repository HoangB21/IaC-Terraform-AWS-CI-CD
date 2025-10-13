data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "hoangtong-tf-state"
    key    = "stg/app/alb/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

# 2 policies for ordered cache behavior (alb)

data "aws_cloudfront_cache_policy" "managed-caching-disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "managed-all-viewer" {
  name = "Managed-AllViewer"
}

module "cloudfront" {
  source = "../../../../modules/network/cloudfront"

  origins = [
    {
      domain_name              = "social-app-fe.s3.ap-southeast-2.amazonaws.com"
      type                     = "s3"
      origin_id                = "s3-origin"
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_access_control_id = "E1CQN46BRLRWB4"
    },
    {
      domain_name            = data.terraform_remote_state.alb.outputs.alb_dns_name
      type                   = "custom"
      origin_id              = "alb-origin"
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  ]

  custom_error_responses = [
    {
      error_caching_min_ttl = 2
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"

    },
    {
      error_caching_min_ttl = 2
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]

  default_behavior = {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forward_query_string   = false
    forward_cookies        = "none"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behaviors = [
    {
      path_pattern             = "/api/*"
      target_origin_id         = "alb-origin"
      viewer_protocol_policy   = "redirect-to-https"
      allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods           = ["GET", "HEAD"]
      cache_policy_id          = data.aws_cloudfront_cache_policy.managed-caching-disabled.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed-all-viewer.id
      min_ttl                  = 0
      default_ttl              = 0
      max_ttl                  = 0
    }
  ]

  default_root_object = "index.html"
}
