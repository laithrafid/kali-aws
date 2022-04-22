output "public_ip" {
  description = "Public IPv4 address of Kali EC2 instance"
  value       = ["${aws_instance.kali_machine.public_ip}"]
}
