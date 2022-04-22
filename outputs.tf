output "build_uuid" {
  description = "UUID that is updated whenever the build has finished. This allows detecting changes."
  value = resource.packer_image.image.build_uuid
}
output "public_ip" {
  description = "Public IPv4 address of Kali EC2 instance"
  value       = ["${aws_instance.kali_machine.public_ip}"]
}

