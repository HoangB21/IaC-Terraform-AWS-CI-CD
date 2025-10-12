resource "aws_launch_template" "this" {
  name_prefix   = var.name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids
  update_default_version = true

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = var.user_data != null ? base64encode(var.user_data) : null

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name = var.name
      },
      var.tags
    )
  }
}
