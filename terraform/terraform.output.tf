# apply後にElastic IPのパブリックIPを出力する
output "public_ip" {
      value = aws_eip.eip.public_ip
}