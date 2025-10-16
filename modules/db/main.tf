resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "this" {
  identifier             = var.name
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  tags                   = var.tags
}

resource "aws_db_instance" "replica" {
  count                   = var.create_replica ? 1 : 0
  replicate_source_db     = aws_db_instance.this.arn
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = var.publicly_accessible
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
}
