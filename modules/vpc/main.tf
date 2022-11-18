# create vpc
resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# create Public Subnet 1
resource "aws_subnet" "PubSn1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PubSn1_cidr
  availability_zone = var.az1
  tags = {
    Name = var.PubSn1
  }
}

# create Public Subnet 2
resource "aws_subnet" "PubSn2" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PubSn2_cidr
  availability_zone = var.az2
  tags = {
    Name = var.PubSn2
  }
}

# create an IGW
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = var.igw_name
  }
}

# create public Subnet route table
resource "aws_route_table" "PubSnRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = var.all
    gateway_id = aws_internet_gateway.Igw.id
  }
  tags = {
    Name = var.PubSnRT
  }
}

# create Route table Association for Public Subnet 1 
resource "aws_route_table_association" "PubRTAss1" {
  subnet_id      = aws_subnet.PubSn1.id
  route_table_id = aws_route_table.PubSnRT.id
}

# create Route table Association for Public Subnet 2
resource "aws_route_table_association" "PubRTAss2" {
  subnet_id      = aws_subnet.PubSn2.id
  route_table_id = aws_route_table.PubSnRT.id
}

# create Private Subnet 1
resource "aws_subnet" "PrvSn1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PrvSn1_cidr
  availability_zone = var.az1
  tags = {
    Name = var.PrvSn1
  }
}

# create Private Subnet 2
resource "aws_subnet" "PrvSn2" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.PrvSn2_cidr
  availability_zone = var.az2
  tags = {
    Name = var.PrvSn2
  }
}

# create elastic ip
resource "aws_eip" "EIP" {
  vpc = true
}
# create Nat gateway
resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.PubSn1.id
  tags = {
    Name = var.Ngw_name
  }
}

# create private route table
resource "aws_route_table" "PrvSnRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = var.all
    nat_gateway_id = aws_nat_gateway.NGW.id
  }
  tags = {
    Name = var.PrvSnRT
  }
}

# create Route table Association for Private Subnet 1 
resource "aws_route_table_association" "PrvRTAss1" {
  subnet_id      = aws_subnet.PrvSn1.id
  route_table_id = aws_route_table.PrvSnRT.id
}

# create Route table Association for Private Subnet 2
resource "aws_route_table_association" "PrvRTAss2" {
  subnet_id      = aws_subnet.PrvSn2.id
  route_table_id = aws_route_table.PrvSnRT.id
}