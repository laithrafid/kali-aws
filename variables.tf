variable "access_key" {
  type        = string
  description = "your aws access key"
  sensitive   = true
}
variable "secret_key" {
  type        = string
  description = "your aws secret key"
  sensitive   = true
}
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ca-central-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS cli profile"
  default     = "default"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block for newly created AWS VPC (e.g. `10.23.0.0/16` or `172.31.0.0/16`) - The Subnet CIDR below must match this VPC CIDR"
  default     = "10.23.0.0/16"
}

variable "subnet_cidr_block" {
  type        = string
  description = "The CIDR block to use for the newly created subnet (e.g. `10.23.0.0/24` or `172.31.0.0/20`) - Must be in range of VPC CIDR"
  default     = "10.23.1.0/24"
}

variable "ssh_key_pair_name" {
  type        = string
  description = "AWS Key pair name of existing SSH Key pair on AWS (e.g. `my-key`)"
  default     = ""
  sensitive   = true
}

variable "public_key_path" {
  type        = string
  sensitive   = true
  description = "Path to your SSH public key (e.g. `~/.ssh/id_rsa.pub`)"
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_id" {
  type        = string
  description = "Use an existing VPC (please set create_vpc to false when using this)"
  default     = ""
}

variable "subnet_id" {
  type        = string
  description = "Use an existting Subnet in an existing VPC (please set create_vpc to false when using this)"
  default     = ""
}

variable "create_vpc" {
  type        = bool
  description = "Create new VPC , Please set to false when setting an existing vpc_id above"
  default     = true
}

variable "use_ipv6" {
  type        = bool
  description = "Use IPv4 AND IPv6 , NOTE: no doublequotes around the true or false"
  default     = false
}

variable "use_ipv4only" {
  type        = bool
  description = "Use IPv4 only , Please set use_ipv6 to false when enabling this"
  default     = true
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type (e.g. `t2.medium` or `t2.small`)"
  default     = "t2.medium"
}

variable "packer_ami" {
  description = "Packer AMI ID to use for EC2 instance (NOTE: run `packer buidl packer.json` and use the generated AMI ID here)"
  #default     = "ami-0a83f486690af787e"
}