resource "aws_key_pair" "key_pair" {
      key_name   = "online-code"
      public_key = file("./online-code.pub")
}

resource "aws_eip" "eip" {
      vpc = true
      depends_on                = [aws_internet_gateway.igw]
}
