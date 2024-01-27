variable "ami" {
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04
  description = "AMI to use for instance creation"
}

variable "instance_type" {
  type        = string
  default     = "t3.nano"
  description = "Instance type to create"
}

variable "num_k8s_controls" {
  type        = number
  default     = 1
  description = "Number of control-plan nodes to create"
}

variable "num_k8s_workers" {
  type        = number
  default     = 3
  description = "Number of worker nodes to create"
}
