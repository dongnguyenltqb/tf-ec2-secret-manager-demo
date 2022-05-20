// EC 2 Instance 
resource "aws_instance" "web" {
  depends_on = [
    aws_iam_instance_profile.profile,
    aws_secretsmanager_secret_version.current
  ]
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.key.key_name
  iam_instance_profile = aws_iam_instance_profile.profile.name
  user_data            = file("./scripts/provision.sh")
  tags = {
    Name = "demo-secret-manager"
  }
}

// remote-exec deploy app
// fetch secret value and restart container
resource "null_resource" "cluster" {
  depends_on = [
    aws_secretsmanager_secret.app
  ]
  triggers = {
    timestamp = timestamp()
  }

  connection {
    host        = aws_instance.web.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    content     = format(file("./scripts/deploy.sh"), aws_secretsmanager_secret.app.id, var.region)
    destination = "/home/ubuntu/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/deploy.sh",
      "/home/ubuntu/deploy.sh",
    ]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "demo-secret-manager"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
