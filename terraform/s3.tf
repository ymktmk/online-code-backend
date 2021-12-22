# S3
resource "aws_s3_bucket" "online-code" {
    acl                         = "private"
    force_destroy               = false
    website {
        error_document = "index.html"
        index_document = "index.html"
    }
}

# パブリックブロックアクセス
resource "aws_s3_bucket_public_access_block" "code-public-access" {
    block_public_acls       = true
    block_public_policy     = true
    bucket                  = aws_s3_bucket.online-code.id
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# バケットポリシー
resource "aws_s3_bucket_policy" "code-bucket-policy" {
    bucket = aws_s3_bucket.online-code.id
    policy = jsonencode(
        {
            Statement = [
                # cloudfrontからの通信のみ許可
                # {
                #     Action    = "s3:GetObject"
                #     Effect    = "Allow"
                #     Principal = "*"
                #     Resource  = "arn:aws:s3:::online-code/*"
                #     Sid       = "BucketPlicy"
                # },
                {
                    Action    = "s3:GetObject"
                    Effect    = "Allow"
                    Principal = {
                        AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3ZIITSGZVWUH"
                    }
                    Resource  = "arn:aws:s3:::online-code/*"
                    Sid       = "1"
                },
            ]
            Version   = "2012-10-17"
        }
    )
}