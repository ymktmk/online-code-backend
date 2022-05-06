# ECSクラスターに存在するEC2
# セキュリティーグループ
resource "aws_security_group" "security_group" {
      name = "golang-ssl-server-sg"
      vpc_id = aws_vpc.vpc.id
      tags = {
            Name = "golang-ssl-server-sg"
      }
}

# インバウンドルール
# 443番ポート解放
resource "aws_security_group_rule" "accept443" {
      security_group_id = aws_security_group.security_group.id
      type              = "ingress"
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
}

# 80番ポート解放
resource "aws_security_group_rule" "accept80" {
      security_group_id = aws_security_group.security_group.id
      type              = "ingress"
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 80
      to_port           = 80
      protocol          = "tcp"
}

# 22番ポート開放
resource "aws_security_group_rule" "accept22" {
      security_group_id = aws_security_group.security_group.id
      type              = "ingress"
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
}

# アウトバウンドルール
resource "aws_security_group_rule" "out_all" {
      security_group_id = aws_security_group.security_group.id
      type              = "egress"
      cidr_blocks       = ["0.0.0.0/0"]
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
}