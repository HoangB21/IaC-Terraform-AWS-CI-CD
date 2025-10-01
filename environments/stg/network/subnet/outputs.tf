output "public_subnet_ids" {
  value = module.public_subnet[*].subnet_id
}

output "private_subnet_ids" {
  value = module.private_subnet[*].subnet_id
}
