# terraform apply -target={aws_iam_policy_document.allow_access_from_cloudfront,aws_cloudfront_distribution.cloudfront_distribution,aws_cloudfront_origin_access_identity.origin_access}
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
      aliases                        = [
            "www.code-run.ga",
      ]
      default_root_object            = "index.html"
      enabled                        = true
      retain_on_delete               = false
      wait_for_deployment            = true
      # エラーページ
      custom_error_response {
            error_caching_min_ttl = 300
            error_code            = 403
            response_code         = 200
            response_page_path    = "/index.html"
      }
      # ビヘイビア
      default_cache_behavior {
            allowed_methods        = ["GET", "HEAD"]
            cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
            cached_methods         = ["GET", "HEAD"]
            compress               = true
            smooth_streaming       = false
            target_origin_id       = "online-code.s3.ap-northeast-1.amazonaws.com"
            viewer_protocol_policy = "redirect-to-https"
      }
      # オリジン
      origin {
            domain_name         = "online-code.s3.ap-northeast-1.amazonaws.com"
            origin_id           = "online-code.s3.ap-northeast-1.amazonaws.com"
            s3_origin_config {
                  origin_access_identity = aws_cloudfront_origin_access_identity.origin_access.cloudfront_access_identity_path
            }
      }
      # 地理的制限
      restrictions {
            geo_restriction {
                  locations        = []
                  restriction_type = "none"
            }
      }
      # SSL証明書
      viewer_certificate {
            acm_certificate_arn            = "arn:aws:acm:us-east-1:009554248005:certificate/7336920c-618d-40d0-a9a6-c7dc466e1184"
            cloudfront_default_certificate = false
            minimum_protocol_version       = "TLSv1.2_2021"
            ssl_support_method             = "sni-only"
      }
}

resource "aws_cloudfront_origin_access_identity" "origin_access" {
      comment = "online-code.s3.amazonaws.com"
}