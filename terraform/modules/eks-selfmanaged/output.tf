output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "node_security_group_id" {
  value = aws_security_group.node_sg.id
}

output "asg_id" {
  value = aws_autoscaling_group.node_asg.id
}
