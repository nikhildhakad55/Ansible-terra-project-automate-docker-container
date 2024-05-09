
  resource "aws_instance" "first" {
  ami           = "ami-014b33341e3a1178e"
  instance_type = "t2.micro"
  key_name   = "fraud"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  tags = {
    Name = "Node1"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.first.public_ip} >> /root/terra/inventory"
                         }
 provisioner "local-exec" {
    command = "sleep 20"
                     }
 provisioner "local-exec" {
    command = "ansible all -m ping"
                     }


  provisioner "local-exec" {
    command = "ansible-playbook web.yml"
                     }

}

resource "aws_instance" "second" {
  ami           = "ami-014b33341e3a1178e"
  instance_type = "t2.micro"
  key_name = "fraud"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  tags = {
    Name = "Node2"
  }
provisioner "local-exec" {
    command = "echo ${aws_instance.second.public_ip} >> /root/terra/inventory"
}

 provisioner "local-exec" {
    command = "sleep 20"
                     }
 provisioner "local-exec" {
    command = "ansible all -m ping"
                     }

provisioner "local-exec" {
    command = "ansible-playbook web.yml"
                     }
}

output "first_publ_ip" {
   value = aws_instance.first.public_ip
}

output "sec_pub_ip" {
   value = aws_instance.second.public_ip
}




resource "aws_security_group" "mysg" {
   name        = "mysg"


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


variable "private_key" {
 default = "fraud"
}
