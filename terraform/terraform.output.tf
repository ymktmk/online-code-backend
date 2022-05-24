output "cloudfront_domain_name" {
      value = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}

output "website_endpoint" {
      value = aws_s3_bucket.bucket.website_endpoint
}

output "elastic_ip" {
      value = aws_eip.eip.public_ip
}