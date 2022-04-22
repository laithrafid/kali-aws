# Terraform & Packer for Kali Linux EC2 instance on AWS

![alt text](images/architecture.png?raw=true)

This repo will Build and deploy a Kali Linux EC2 instance by utilizing Packer by using the official Kali Linux AMI and and apt-get dist-upgrade to be up-to-date with the Kali Linux Rolling Release.

If you don't want to run Packer, just provide Terraform with a variable of ami of kali image from aws in your region which will be used to deploy the default Kali Linux AMI  


PROTIP: You can choose a GPU EC2 instance type to have additional hash cracking power 🤓


# requirements 
1. aws credntials 
2. subscribe to [Kali image](https://aws.amazon.com/marketplace/fulfillment?productId=804fcc46-63fc-4eb6-85a1-50e66d6c7215&ref_=dtl_psb_continue) you have to accept the terms and conditions of the Kali Linux AMI (this is an requirement of the AWS Marketplace (this is an requirement of the AWS Marketplace)
3. terraform
4. packer (will be installed as a provider in background, if you need to maunally build then install it)

# Usage

1. clone repo
`git clone `  

2. Packer: Build your custom AMI
`packer build `
This will start a temporary EC2 instance with an atttached EBS volume and the official Kali Linux AMI as source_ami. Then it executes the inline shell commands in the provisioners section as root (_execute_command) and sets an environment variable so apt works noninteractive (_environmentvars).

The generated AMI name will be in the format of: kali-linux-aws-{{timestamp}}.

When Packer has successfully finished it’s job, you get an AMI ID at the end. This may look like this (here I show you the AMI ID of the official Kali Linux AMI, you’re packer execution results in a unique ID of course):
```
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
eu-central-1: ami-10e00b6d
```
Note down this AMI ID because we will use this in Terraform during the next step.

3. copy terraform.tfvars.template to terraform.tfvars and fill with your variables
```
access_key        = "your aws access_key"
secret_key        = "your aws secret_key"
aws_profile       = "default"
aws_region        = "ca-central-1"
create_vpc        = true
ec2_instance_type = "t2.medium"
packer_ami        = "ami-0a83f486690af787e"
public_key_path   = "~/.ssh/id_rsa.pub"
ssh_key_pair_name = ""
subnet_cidr_block = "10.23.1.0/24"
subnet_id         = ""
use_ipv4only      = true
use_ipv6          = false
vpc_cidr          = "10.23.0.0/16"
vpc_id            = ""
```
4. Run a terraform plan to review all resources:
`terraform plan -var-file=terraform.tfvars`
5. Run terraform apply to deploy this configuration on AWS:
`terraform apply -var-file=terraform.tfvars`

# Connect to your Kali EC2 instance
Finally, after Terraform has completed, the public IPv4 address of the EC2 instance is displayed to you. You can connect to your new instance with the SSH key you configured earlier and the user ec2-user 
or rdp using VNC, RDP or some alternative tool like [apache guacamole](https://guacamole.apache.org/doc/gug/configuring-guacamole.html) 

# Terraform
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.kali_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.ssh_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route_table.rt-ipv4only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.rt-ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.rtassoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.sg-ipv4-only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg-ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.new-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS cli profile | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"ca-central-1"` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Create new VPC , Please set to false when setting an existing vpc\_id above | `bool` | `true` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | EC2 instance type (e.g. `t2.medium` or `t2.small`) | `string` | `"t2.medium"` | no |
| <a name="input_packer_ami"></a> [packer\_ami](#input\_packer\_ami) | Packer AMI ID to use for EC2 instance (NOTE: run `packer buidl packer.json` and use the generated AMI ID here) | `string` | `"ami-0a83f486690af787e"` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to your SSH public key (e.g. `~/.ssh/id_rsa.pub`) | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | AWS Key pair name of existing SSH Key pair on AWS (e.g. `my-key`) | `string` | `""` | no |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | The CIDR block to use for the newly created subnet (e.g. `10.23.0.0/24` or `172.31.0.0/20`) - Must be in range of VPC CIDR | `string` | `"10.23.1.0/24"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Use an existting Subnet in an existing VPC (please set create\_vpc to false when using this) | `string` | `""` | no |
| <a name="input_use_ipv4only"></a> [use\_ipv4only](#input\_use\_ipv4only) | Use IPv4 only , Please set use\_ipv6 to false when enabling this | `bool` | `true` | no |
| <a name="input_use_ipv6"></a> [use\_ipv6](#input\_use\_ipv6) | Use IPv4 AND IPv6 , NOTE: no doublequotes around the true or false | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR block for newly created AWS VPC (e.g. `10.23.0.0/16` or `172.31.0.0/16`) - The Subnet CIDR below must match this VPC CIDR | `string` | `"10.23.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Use an existing VPC (please set create\_vpc to false when using this) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IPv4 address of Kali EC2 instance |


# References
* If you want to completely build your own Kali Linux, you can use the official [kali-cloud-build](https://gitlab.com/kalilinux/build-scripts/kali-cloud-build) tools.

* github.com:hajowieland/terraform-kali-linux.git
* https://napo.io/posts/terraform-packer-to-create-a-kali-linux-aws-ec2-instance/#set-up-your-aws-credentials