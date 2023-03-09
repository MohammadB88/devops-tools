resource "aws_vpc" "kubernetes" {
  cidr_block = "172.51.0.0/16"

  tags = {
    Name = "kubernetes"
  }
}


resource "aws_subnet" "k8s_subnet" {
  vpc_id            = aws_vpc.kubernetes.id
  cidr_block        = "172.51.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "k8s_subnet"
  }
}


resource "aws_internet_gateway" "k8s_gw" {
  vpc_id = aws_vpc.kubernetes.id

  tags = {
    Name = "k8s-gw"
  }
}

resource "aws_route_table" "k8s_rt" {
  vpc_id = aws_vpc.kubernetes.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_gw.id
  }

  tags = {
    Name = "k8s-rt"
  }
}

resource "aws_route_table_association" "k8s_rta" {
  subnet_id      = aws_subnet.k8s_subnet.id
  route_table_id = aws_route_table.k8s_rt.id
}

# resource "aws_subnet" "public" {
#   vpc_id            = aws_vpc.kubernetes.id
#   cidr_block        = "172.51.1.0/24"
#   availability_zone = "eu-central-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public"
#   }
# }

# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.kubernetes.id
#   cidr_block        = "172.51.2.0/24"
#   availability_zone = "eu-central-1b"

#   tags = {
#     Name = "private"
#   }
# }
