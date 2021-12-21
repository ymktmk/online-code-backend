# VPC
resource "aws_vpc" "code-vpc" {
    cidr_block                       = "10.0.0.0/16"
    enable_dns_hostnames             = true
    enable_dns_support               = true
    instance_tenancy                 = "default"
    tags                             = {
        "Name" = "code"
    }
}

# パブリックサブネット
resource "aws_subnet" "code-public-subnet" {
    availability_zone               = "ap-northeast-1a"
    cidr_block                      = "10.0.0.0/24"
    # サブネットで起動したインスタンスにパブリックIPを許可する
    map_public_ip_on_launch = true
    tags                            = {
        "Name" = "public"
    }
    vpc_id                          = aws_vpc.code-vpc.id
}

# プライベートサブネット
resource "aws_subnet" "code-private-subnet" {
    availability_zone               = "ap-northeast-1c"
    cidr_block                      = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags                            = {
        "Name" = "private"
    }
    vpc_id                          = aws_vpc.code-vpc.id
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "code-igw" {
    tags     = {
        "Name" = "code"
    }
    vpc_id   = aws_vpc.code-vpc.id
}

# ルートテーブル
resource "aws_route_table" "code-route-table" {
    route {
        cidr_block                 = "0.0.0.0/0"
        gateway_id                 = aws_internet_gateway.code-igw.id
    }
    
    tags             = {
        "Name" = "code"
    }
    vpc_id           = aws_vpc.code-vpc.id
}

# ルートテーブルをパブリックサブネットに紐付け
resource "aws_route_table_association" "code-public-subnet-association" {
    route_table_id = aws_route_table.code-route-table.id
    subnet_id      = aws_subnet.code-public-subnet.id
}

# ルートテーブルをプライベートサブネットに紐付け
resource "aws_route_table_association" "code-private-subnet-association" {
    route_table_id = aws_route_table.code-route-table.id
    subnet_id      = aws_subnet.code-private-subnet.id
}