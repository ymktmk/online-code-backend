# ssh-keygen -t rsa -f ymktmk -N ''
# ssh -i ./ymktmk ec2-user@<IP>
resource "aws_key_pair" "key_pair" {
      key_name   = "ttttt"
      public_key = file("./ttttt.pub")
}

# Elastic IPを InternetGatewayに紐付ける 
resource "aws_eip" "eip" {
      vpc = true
      depends_on                = [aws_internet_gateway.igw]
}