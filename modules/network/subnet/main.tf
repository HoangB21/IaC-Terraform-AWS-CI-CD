resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.is_public

  tags = merge(
    {
      Name = "${var.subnet_name}-${var.is_public ? "public" : "private"}"
    },
    var.tags
  )
}

# Route Table
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.subnet_name}-rt-${var.is_public ? "public" : "private"}"
    },
    var.tags
  )
}

# Route for public subnet (if is_public = true)
resource "aws_route" "public_internet_access" {
  count = var.is_public ? 1 : 0

  route_table_id         = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

# Associate subnet with route table
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}
