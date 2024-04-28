output "private_instance_ids" {
  value = aws_instance.private[*].id
}

output "public_instance_id" {
  value = aws_instance.public.id
}

output "instance_states" {
  value = aws_instance.public[*].instance_state
}