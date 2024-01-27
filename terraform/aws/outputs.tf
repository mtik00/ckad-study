output "control_ips" {
  value = aws_instance.k8s_control_nodes.*.public_ip
}

output "worker_ips" {
  value = aws_instance.k8s_worker_nodes.*.public_ip
}
