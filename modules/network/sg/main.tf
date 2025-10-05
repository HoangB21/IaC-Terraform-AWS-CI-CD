resource "aws_security_group" "this" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = var.sg_name
    },
    var.tags
  )
}

module "sg_inbound_rules" {
  source            = "../sg_rules"
  security_group_id = aws_security_group.this.id
  rules             = var.sg_inbound_rules
  type              = "ingress"
}

module "sg_outbound_rules" {
  source            = "../sg_rules"
  security_group_id = aws_security_group.this.id
  rules             = var.sg_outbound_rules
  type              = "egress"
}
