# ssh-keygen -t rsa -f online-code -N ''
# ssh -i ./online-code ec2-user@<IP>
resource "aws_key_pair" "key_pair" {
      key_name   = "online-code"
      public_key = file("./online-code.pub")
}

# Elastic IPを InternetGatewayに紐付ける 
resource "aws_eip" "eip" {
      vpc = true
      depends_on                = [aws_internet_gateway.igw]
}