resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.prefix}-ecs-instance-role"
  assume_role_policy = file("${path.module}/policies/ecs_role.json")
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${var.prefix}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role_policy" "ecs_role" {
  name   = "${var.prefix}-ecs-role-policy"
  policy = file("${path.module}/policies/ecs_role_policy.json")
  role   = aws_iam_role.ecs_instance_role.id
}

resource "aws_iam_role_policy" "ecs_scheduler_role" {
  name   = "${var.prefix}-ecs-scheduler-role"
  policy = file("${path.module}/policies/ecs_scheduler_role_policy.json")
  role   = aws_iam_role.ecs_instance_role.id
}

resource "aws_iam_role_policy" "ecs_cloudwatch_logs" {
  name   = "${var.prefix}-ecs-cloudwatch-logs"
  policy = file("${path.module}/policies/ecs_cloudwatch_logs.json")
  role   = aws_iam_role.ecs_instance_role.id
}
