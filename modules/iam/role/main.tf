resource "aws_iam_role" "this" {
  name               = var.name
  description        = var.description
  assume_role_policy = var.assume_role_policy

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

# Optionally attach managed policies to the IAM role
resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy != null ? 1 : 0
  name   = "${var.name}-inline-policy"
  role   = aws_iam_role.this.id
  policy = var.inline_policy
}
