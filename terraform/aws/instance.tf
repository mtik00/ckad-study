resource "aws_instance" "k8s_control_nodes" {
  count         = var.num_k8s_controls
  ami           = var.ami
  instance_type = var.instance_type
}

resource "aws_instance" "k8s_worker_nodes" {
  count         = var.num_k8s_workers
  ami           = var.ami
  instance_type = var.instance_type
}
