# S3（静的Webホスティング機能）
resource "aws_s3_bucket" "bucket" {
      bucket  = "online-code"
      versioning {
            enabled = false
      }
      website {
            index_document = "index.html"
            error_document = "index.html"
      } 
}

# バケットポリシー
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
      bucket = aws_s3_bucket.bucket.id
      policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
      statement {
            sid    = "bucket-policy"
            principals {
                  type        = "AWS"
                  identifiers = ["${aws_cloudfront_origin_access_identity.origin_access.iam_arn}"]
            }
            effect = "Allow"
            actions = ["s3:GetObject"]
            resources = [
                  "${aws_s3_bucket.bucket.arn}/*"
            ]
      }
}

# パブリックブロックアクセス
resource "aws_s3_bucket_public_access_block" "public_access_block" {
      bucket = aws_s3_bucket.bucket.id
      block_public_acls = true
      block_public_policy = true
      ignore_public_acls = true
      restrict_public_buckets = true
}
