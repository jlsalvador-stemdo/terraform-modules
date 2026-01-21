output "instance_ids" {
  value = { for name, inst in aws_instance.web : name => inst.id }
}