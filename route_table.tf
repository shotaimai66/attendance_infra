resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.r_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "public_subnet_1a_rt_assoc" {
  subnet_id      = "${aws_subnet.public_subnet_1a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_1c_rt_assoc" {
  subnet_id      = "${aws_subnet.public_subnet_1c.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

