variable "name" {
  description = "Unique name/identifier for the DB instance."
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., mysql, postgres)."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version."
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "Instance size (e.g., db.t3.micro)."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial allocated storage (in GB)."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "username" {
  description = "Master username for the database."
  type        = string
}

variable "password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before deletion."
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Whether the database instance is publicly accessible."
  type        = bool
  default     = false
}

variable "create_replica" {
  description = "Whether to create a read replica of the primary DB instance."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for the read replica."
  type        = number
  default     = 0
}
