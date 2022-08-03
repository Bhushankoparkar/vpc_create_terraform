
resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(var.tag, {"owner" = format("%s_%s_%s", var.env, var.owner, "public")})
  # tags = {
  #   Name = "${var.tag}_vpc"
  #          #var.tag
  # }
}

resource "aws_subnet" "public" {
  count      = length(var.public_cidr)
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_cidr[count.index]
# availability_zone = var.availability_zone[count.index]
  availability_zone = element(var.availability_zone, count.index) #----------element veriable (continuos repet avability zone cycle)
  
  tags = merge(var.tag, {"owner" = format("%s_%s_%s", var.env, var.owner, "public")})
  # tags = {
  #   Name = "${var.tag}_public_subnet"
  # }


}

resource "aws_subnet" "private" {
  count      = length(var.private_cidr)
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_cidr[count.index]
# availability_zone = var.availability_zone[count.index]
  availability_zone = element(var.availability_zone, count.index) #----------element veriable (continuos repet avability zone cycle)
  
  tag = {"envernment" = var.env}
  # tags = {
  #   Name = "${var.tag}_private_subnet"
  # }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tag, {"owner" = format("%s_%s_%s", var.env, var.owner, "public")})
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route = []

}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  depends_on                = [aws_route_table.private]
# gateway_id = aws_internet_gateway.igw.id  #--------------Internet gateway
  nat_gateway_id = aws_nat_gateway.nat.id  #--------------NAT gateway
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[2].id
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_vpn_gateway_route_propagation" "example" {
  vpn_gateway_id = aws_vpn_gateway.example.id
  route_table_id = aws_route_table.example.id
}
