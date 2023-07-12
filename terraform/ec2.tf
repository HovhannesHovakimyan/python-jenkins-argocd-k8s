resource "aws_instance" "ec2_jenkins" {
  ami                    = "ami-0aea56f3589631913"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public-eu-central-1a
  vpc_security_group_ids = [aws_security_group.ec2_jenkins.id]
  key_name               = aws_key_pair.key_pair.key_name

  tags = {
    Name    = "ec2-jenkins-instance"
    Purpose = "test"
  }

  provisioner "file" {
    source      = "install_jenkins.yml"
    destination = "/home/ec2-user/install_jenkins.yml"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/aws-test-keypair.pem")
    host        = aws_instance.ec2_jenkins.public_ip
    timeout     = "30s"
  }
}

resource "null_resource" "install_jenkins" {
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo chmod +x /home/ec2-user/install_jenkins.yml",
      "sudo ansible-playbook install_jenkins.yml"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/aws-test-keypair.pem")
      host        = aws_instance.ec2_jenkins.public_ip
      timeout     = "30s"
    }
  }

  depends_on = [aws_instance.ec2_jenkins]
}
