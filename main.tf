### EC2 ###

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "wordpress_web" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.subnet_id_1
  vpc_security_group_ids  = ["${aws_security_group.wordpress_web.id}"]
  depends_on              = [aws_efs_mount_target.alpha]

  provisioner "remote-exec" {
    inline = [
      "sudo apt install nfs-common -y",
      "sudo mkdir /var/www/",
      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.wordpress_fs.dns_name}:/ /var/www/",
      "echo '${aws_efs_file_system.wordpress_fs.dns_name}:/  /var/www  nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0' | sudo tee -a /etc/fstab"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ec2_key
    host        = self.private_ip
  }

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

### EFS ###

resource "aws_efs_file_system" "wordpress_fs" {
  creation_token = var.efs_token
  encrypted      = true

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id  = aws_efs_file_system.wordpress_fs.id
  subnet_id       = var.subnet_id_1
  security_groups = ["${aws_security_group.wordpress_web.id}"]
}

### RDS MySQL ###

resource "aws_db_instance" "wordpress_db" {
  allocated_storage           = var.db_storage
  storage_type                = var.db_storage_type
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_type
  identifier                  = var.db_hostname
  name                        = var.db_name
  username                    = var.db_username
  password                    = var.db_userpass
  parameter_group_name        = var.db_parameter_group
  backup_retention_period     = var.backup_retention
  skip_final_snapshot         = var.skip_final_snap
  storage_encrypted           = var.encrypted_db 
  allow_major_version_upgrade = var.allow_major_upgrade
  db_subnet_group_name        = aws_db_subnet_group.wordpress_db.name
  vpc_security_group_ids      = ["${aws_security_group.wordpress_db.id}"]

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "wordpress_db" {
  name       = "wordpress-subnet-group"
  subnet_ids = [var.subnet_id_1,var.subnet_id_2,var.subnet_id_3]

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

### ELB ###

resource "aws_elb" "wp_lb" {
  name               = "wordpress-lb"
  subnets            = [var.pub_subnet_1,var.pub_subnet_2,var.pub_subnet_3]
  instances          = ["${aws_instance.wordpress_web.id}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.elb_cert
  }
}

resource "aws_load_balancer_policy" "wp_lb_cypher" {
  load_balancer_name = "${aws_elb.wp_lb.name}"
  policy_name        = "SSL-Policy"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "Reference-Security-Policy"
    value = "ELBSecurityPolicy-TLS-1-2-2017-01"
  }

  lifecycle {
    ignore_changes = ["policy_attribute"]
  }
}

resource "aws_load_balancer_listener_policy" "wp_lb_policy" {
  load_balancer_name = "${aws_elb.wp_lb.name}"
  load_balancer_port = 443

  policy_names = [
    "${aws_load_balancer_policy.wp_lb_cypher.policy_name}",
  ]
}

### Route 53 ###

data "aws_route53_zone" "public" {
  zone_id = var.dns_zone
}

resource "aws_route53_record" "blog" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "blog.${data.aws_route53_zone.public.name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.wp_lb.dns_name}"
    zone_id                = "${aws_elb.wp_lb.zone_id}"
    evaluate_target_health = false
  }
}

### Security Groups ###

resource "aws_security_group" "wordpress_web" {
  name        = "wordpress-web"
  description = "Wordpress SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = var.wordpress_web_ssh_sg
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = var.wordpress_web_http_sg
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.wordpress_web_https_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

resource "aws_security_group" "wordpress_db" {
  name        = "wordpress-db"
  description = "Wordpress DB SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.wordpress_db_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}

resource "aws_security_group" "elb" {
  name        = "wordpress-lb"
  description = "Wordpress ELB SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = var.projectname
    Environment = var.environment
  }
}