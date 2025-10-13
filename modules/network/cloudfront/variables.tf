variable "comment" {
  type        = string
  description = "Description or comment for the CloudFront distribution."
  default     = "Managed by Terraform"
}

variable "default_root_object" {
  type        = string
  description = "The default object to serve when no specific object is requested."
  default     = "index.html"
}

variable "price_class" {
  type        = string
  description = "The CloudFront price class (e.g., PriceClass_100, PriceClass_200, PriceClass_All)."
  default     = "PriceClass_100"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the CloudFront distribution."
  default     = {}
}

# Origin configuration
variable "origins" {
  description = <<EOT
List of origin definitions.
Each origin requires:
- domain_name: The domain name of the origin.
- origin_id: Unique identifier for the origin.
- http_port / https_port: Ports used for communication.
- origin_protocol_policy: Either 'http-only', 'https-only', or 'match-viewer'.
- origin_ssl_protocols: List of SSL protocols supported.
EOT
  type = list(object({
    domain_name              = string
    type                     = string           # "s3" or "custom"
    origin_access_identity   = optional(string) # Required if type is "s3"
    origin_id                = string
    http_port                = number
    https_port               = number
    origin_protocol_policy   = string
    origin_ssl_protocols     = list(string)
    origin_access_control_id = optional(string)
  }))
}

# Default cache behavior
variable "default_behavior" {
  description = "Default cache behavior configuration for CloudFront."
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    forward_query_string   = bool
    forward_cookies        = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
  })
}

variable "custom_error_responses" {
  description = <<EOT
Map of custom error responses.
Each entry requires:
- response_code: The HTTP status code that you want CloudFront to return to the viewer along with the custom error page.
- response_page_path: The path to the custom error page that you want CloudFront to return to the viewer.
- error_caching_min_ttl: The minimum amount of time, in seconds, that you want CloudFront to cache the HTTP status code specified in ErrorCode.
EOT
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []

}

# Ordered cache behaviors (optional)
variable "ordered_cache_behaviors" {
  description = "Optional list of additional cache behaviors."
  type = list(object({
    path_pattern             = string
    target_origin_id         = string
    viewer_protocol_policy   = string
    allowed_methods          = list(string)
    cached_methods           = list(string)
    forward_query_string     = optional(bool)
    forward_cookies          = optional(string)
    cache_policy_id          = string
    origin_request_policy_id = string
    min_ttl                  = number
    default_ttl              = number
    max_ttl                  = number
  }))
  default = []
}
