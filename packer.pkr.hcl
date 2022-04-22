
variable "access_key" {
  type    = string
  sensitive = true
}

variable "secret_key" {
  type    = string
  sensitive = true
}

variable "region" {
  type    = string
  default = "ca-central-1"
}
variable "packer_ami_image_name"{
  type = string
}

source "amazon-ebs" "autogenerated_1" {
  access_key    = "${var.access_key}"
  ami_name      = "${var.packer_ami_image_name}"
  instance_type = "t2.medium"
  region        = "ca-central-1"
  secret_key    = "${var.secret_key}"
  source_ami    = "ami-0a83f486690af787e"
  ssh_username  = "kali"
  tags = {
    Base_AMI_Name = "{{ .SourceAMIName }}"
    OS_Version    = "Kali Linux"
    Project       = "Kali"
    Release       = "Latest"
  }
}

build {
  sources = ["source.amazon-ebs.autogenerated_1"]

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    execute_command  = "sudo -S env {{ .Vars }} {{ .Path }}"
    inline           = [
    "apt-get -y update",
    "apt-get full-upgrade -y",
    "apt-get -y dist-upgrade",
    "apt-get install -y kali-desktop-xfce xorgxrdp xrdp",
    "systemctl enable xrdp --now",
    "apt -o Dpkg::Options::='--force-confnew' -q --force-yes -y full-upgrade",
    "apt-get autoremove -q -y",
    "apt-get autoclean -q -y",
    "apt-get install burpsuite"
    ]
  }

}
