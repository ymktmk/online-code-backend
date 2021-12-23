# resource "aws_cloudfront_distribution" "code-distribution" {

#     aliases                        = [
#         - "www.code-run.ga",
#     ]

#     default_root_object            = "index.html"
#     is_ipv6_enabled                = true
#     enabled                        = true

#     custom_error_response {
#         error_caching_min_ttl = 300
#         error_code            = 403
#         response_code         = 200
#         response_page_path    = "/index.html"
#     }

#     default_cache_behavior {
#         allowed_methods        = [ "GET", "HEAD" ]
#         cached_methods         = [ "GET", "HEAD" ]
#         compress               = true
#         default_ttl            = 0
#         max_ttl                = 0
#         min_ttl                = 0
#         target_origin_id       = aws_s3_bucket.online-code.id
#         viewer_protocol_policy = "redirect-to-https"
#     }

#     origin {
#         domain_name         = aws_s3_bucket.online-code.bucket_regional_domain_name
#         origin_id           = aws_s3_bucket.online-code.id
#         s3_origin_config {
#             origin_access_identity = "origin-access-identity/cloudfront/E3ZIITSGZVWUH"
#         }
#     }

#     restrictions {
#         geo_restriction {
#             locations        = []
#             restriction_type = "none"
#         }
#     }

#     # ？
#     viewer_certificate {
#         cloudfront_default_certificate = false
#     }
# }