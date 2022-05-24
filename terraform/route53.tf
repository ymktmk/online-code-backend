resource "aws_route53_zone" "zone" {
      name = "code-run.ga"
      force_destroy = false
}

# APIのドメイン
resource "aws_route53_record" "api" {
      zone_id = aws_route53_zone.zone.zone_id
      name    = "api.code-run.ga"
      type    = "A"
      ttl     = "300"
      records = [aws_eip.eip.public_ip]
}