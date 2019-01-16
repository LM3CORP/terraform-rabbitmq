output "rabbitmq_servers_ip" {
  value = ["${aws_instance.rabbitmq_server.*.public_ip}"]
}

output "rabbitmq_servers_dns" {
  value = ["${aws_instance.rabbitmq_server.*.public_dns}"]
}
