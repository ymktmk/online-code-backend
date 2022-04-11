# VPC
resource "aws_vpc" "vpc" {
    cidr_block                       = "10.0.0.0/16"
    enable_dns_hostnames             = true
    enable_dns_support               = true
    instance_tenancy                 = "default"
    tags                             = {
        "Name" = "online-code"
    }
}

# パブリックサブネット
resource "aws_subnet" "public_subnet" {
    vpc_id                          = aws_vpc.vpc.id
    availability_zone               = "ap-northeast-1a"
    cidr_block                      = "10.0.0.0/24"
    # サブネットで起動したインスタンスにパブリックIPを許可する
    map_public_ip_on_launch = true
    tags                            = {
        "Name" = "public_subnet"
    }
}

# プライベートサブネット
resource "aws_subnet" "private_subnet" {
    availability_zone               = "ap-northeast-1c"
    cidr_block                      = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags                            = {
        "Name" = "private_subnet"
    }
    vpc_id                          = aws_vpc.vpc.id
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "igw" {
    vpc_id   = aws_vpc.vpc.id
    tags     = {
        "Name" = "online-code"
    }
}

# ルートテーブル
resource "aws_route_table" "route_table" {
    vpc_id           = aws_vpc.vpc.id
    route {
        cidr_block                 = "0.0.0.0/0"
        gateway_id                 = aws_internet_gateway.igw.id
    }
    tags             = {
        "Name" = "online-code"
    }
}

# ルートテーブルをパブリックサブネットに紐付け
# これでパブリックサブネットが外部に公開された状態に
resource "aws_route_table_association" "public_subnet_association" {
    route_table_id = aws_route_table.route_table.id
    subnet_id      = aws_subnet.public_subnet.id
}