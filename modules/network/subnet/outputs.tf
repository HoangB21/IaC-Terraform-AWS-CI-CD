output "subnet_id" {
  description = "The ID of the created subnet."
  value       = aws_subnet.this.id
}

output "route_table_id" {
  description = "The ID of the route table associated with the subnet."
  value       = aws_route_table.this.id
}
