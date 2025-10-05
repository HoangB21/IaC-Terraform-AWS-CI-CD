resource "aws_security_group_rule" "this" {
  for_each = {
    for idx, rule in var.rules : idx => rule
  }

  type              = var.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = var.security_group_id
  description       = lookup(each.value, "description", null)

  # cidr_blocks || source_security_group_id
  cidr_blocks              = try(each.value.cidr_blocks, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
