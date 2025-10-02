resource "aws_security_group_rule" "this" {
  type              = var.type
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  security_group_id = var.security_group_id
  dynamic "cidr_blocks" {
    for_each = var.source_security_group_id == null ? [1] : []
    content {
      cidr_blocks = var.cidr_blocks
    }
  }

  dynamic "source_security_group_id" {
    for_each = var.source_security_group_id != null ? [1] : []
    content {
      source_security_group_id = var.source_security_group_id
    }
  }
  description = var.description
}
