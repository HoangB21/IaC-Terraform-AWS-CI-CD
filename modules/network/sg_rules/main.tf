resource "aws_security_group_rule" "this_cidr" {
  count             = var.source_security_group_id == null ? 1 : 0
  type              = var.type
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  cidr_blocks       = var.cidr_blocks
  security_group_id = var.security_group_id
  description       = var.description
}

resource "aws_security_group_rule" "this_sg" {
  count                    = var.source_security_group_id != null ? 1 : 0
  type                     = var.type
  from_port                = var.from_port
  to_port                  = var.to_port
  protocol                 = var.protocol
  security_group_id        = var.security_group_id
  source_security_group_id = var.source_security_group_id
  description              = var.description
}
