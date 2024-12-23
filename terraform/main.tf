resource "aws_vpc" "kxc-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "kxc-vpc"
  }
}

resource "aws_internet_gateway" "kxc-igw"{
    vpc_id = aws_vpc.kxc-vpc.id
    tags = {
        Name = "kxc-igw"
  }
}

resource "aws_subnet" "kxc-public-1a" {
    vpc_id = aws_vpc.kxc-vpc.id 
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
    Name = "kxc-public-1a"
  }
}

resource "aws_subnet" "kxc-public-1b" {
    vpc_id = aws_vpc.kxc-vpc.id 
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
    Name = "kxc-public-1b"
  }
}

resource "aws_subnet" "kxc-public-1c" {
    vpc_id = aws_vpc.kxc-vpc.id 
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
    tags = {
    Name = "kxc-public-1c"
  }
}

resource "aws_subnet" "kxc-private-1a" {
    vpc_id = aws_vpc.kxc-vpc.id 
    cidr_block = "10.0.101.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
    Name = "kxc-private-1a"
  }
}

resource "aws_subnet" "kxc-private-1b" {
    vpc_id = aws_vpc.kxc-vpc.id 
    cidr_block = "10.0.102.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
    Name = "kxc-private-1b"
  }
}

resource "aws_subnet" "kxc-private-1c" {
    vpc_id = aws_vpc.kxc-vpc.id 
    cidr_block = "10.0.103.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = false
    tags = {
    Name = "kxc-private-1c"
  }
}

resource "aws_route_table" "kxc-rt-public" {
    vpc_id = aws_vpc.kxc-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.kxc-igw.id
    }
    tags = {
      Name = "kxc-rt-public"
    }
}

resource "aws_route_table" "kxc-rt-private" {
    vpc_id = aws_vpc.kxc-vpc.id
    tags = {
      Name = "kxc-rt-private"
    }
}

resource "aws_db_subnet_group" "db_group_private" {
    name = "kxc-db-subnet-private"
    subnet_ids = [
      aws_subnet.kxc-private-1a.id, 
      aws_subnet.kxc-private-1b.id, 
      aws_subnet.kxc-private-1c.id
      ]
    tags = {
        Name = "kxc-db-subnet-private"
    }
}

resource "aws_route_table_association" "public" {
    for_each = {
        public1 = aws_subnet.kxc-public-1a.id,
        public2 = aws_subnet.kxc-public-1b.id,
        public3 = aws_subnet.kxc-public-1c.id
    }

    route_table_id = aws_route_table.kxc-rt-public.id
    subnet_id = each.value
}

resource "aws_route_table_association" "private" {
    for_each = {
        private1 = aws_subnet.kxc-private-1a.id,
        private2 = aws_subnet.kxc-private-1b.id,
        private3 = aws_subnet.kxc-private-1c.id
    }

    route_table_id = aws_route_table.kxc-rt-private.id
    subnet_id = each.value
}