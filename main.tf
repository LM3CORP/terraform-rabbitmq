provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source        = "github.com/turnbullpress/tf_vpc.git?ref=v0.0.1"
  name          = "rabbitmq"
  cidr          = "10.0.0.0/16"
  public_subnet = "10.0.2.0/24"
}

#data "template_file" "rabbitmq_config" {
#  template = "${file("files/rabbitmq.conf.tpl")}"
#}

resource "aws_instance" "rabbitmq_server" {
  ami                         = "${lookup(var.server_ami, var.region)}"         //need to do a lookup later
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.vpc.public_subnet_id}"
  private_ip                  = "${var.instance_server_ips[count.index]}"
  associate_public_ip_address = true
  user_data                   = "${file("files/rabbitmq_server_bootstrap.sh")}"

  vpc_security_group_ids = [
    "${aws_security_group.rabbitmq_server_incoming_sg.id}",
  ]

  connection {
    type        = "ssh"
    agent       = false
    user        = "ubuntu"
    private_key = "${file("~/.ssh/lm3corp.pem")}"
  }

  provisioner "file" {
    source      = "files/rabbitmq-setup.sh"
    destination = "/tmp/rabbitmq-setup.sh"
  }

  #provisioner "file"{
  #  
  #}

  #download and install nomad server as a service
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/rabbitmq-setup.sh",
      "/tmp/rabbitmq-setup.sh",
    ]
  }
  tags {
    Name = "rabbitmq-server-${format("%03d", count.index + 1)}"
  }
  count = "${length(var.instance_server_ips)}"
}

resource "aws_security_group" "rabbitmq_server_incoming_sg" {
  name        = "rabbitmq_server_inbound"
  description = "Allow Incoming RabbitMq"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = "15672"
    to_port     = "15672"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "5672"
    to_port     = "5672"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  /*
                          ingress {
                            from_port   = 8
                            to_port     = 0
                            protocol    = "icmp"
                            cidr_blocks = ["0.0.0.0/0"]
                          }
                        */
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
