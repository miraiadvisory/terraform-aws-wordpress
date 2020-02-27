variable "instance_type" {
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
  default     = ""
  type        = string
}

variable "key_name" {
  description = "AWS Key to assign to instance"
  default     = ""
  type        = string
}

variable "subnet_id_1" {
  description = "The VPC private subnet ID in which to launch the EC2 instance"
  default     = ""
  type        = string
}

variable "subnet_id_2" {
  description = "Second VPC private subnet ID, used to populate aws_db_subnet_group.subnet_ids"
  default     = ""
  type        = string
}

variable "subnet_id_3" {
  description = "Third VPC private subnet ID, used to populate aws_db_subnet_group.subnet_ids"
  default     = ""
  type        = string
}

variable "pub_subnet_1" {
  description = "First VPC public subnet ID, used to populate aws_elb.subnets"
  default     = ""
  type        = string
}

variable "pub_subnet_2" {
  description = "Second VPC public subnet ID, used to populate aws_elb.subnets"
  default     = ""
  type        = string
}

variable "pub_subnet_3" {
  description = "Third VPC public subnet ID, used to populate aws_elb.subnets"
  default     = ""
  type        = string
}

variable "dns_zone" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  default     = ""
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  default     = ""
  type        = string
}

variable "wordpress_web_ssh_sg" {
  description = "List of security group IDs to be given SSH access"
  default     = [""]
  type        = list(string)
}

variable "wordpress_web_http_sg" {
  description = "List of security group IDs to be given HTTP access"
  default     = [""]
  type        = list(string)
}

variable "wordpress_web_https_sg" {
  description = "List of security group IDs to be given HTTPS access"
  default     = [""]
  type        = list(string)
}

variable "wordpress_db_sg" {
  description = "List of security group IDs to be given MySQL access"
  default     = [""]
  type        = list(string)
}

variable "db_storage" {
  description = "The allocated storage in gibibytes"
  default     = 20
  type        = number
}

variable "db_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "gp2"
  type        = string
}

variable "db_engine" {
  description = "The database engine"
  default     = "mysql"
  type        = string
}

variable "db_engine_version" {
  description = "The database engine version"
  default     = "5.7"
  type        = string
}

variable "db_instance_type" {
  description = "The RDS instance class"
  default     = ""
  type        = string
}

variable "db_hostname" {
  description = "(Optional, Forces new resource) The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  default     = ""
  type        = string
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  default     = ""
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user"
  default     = ""
  type        = string
}

variable "db_userpass" {
  description = "Password for the master DB user"
  default     = ""
  type        = string
}

variable "db_parameter_group" {
  description = "Name of the DB parameter group to associate"
  default     = "default.mysql5.7"
  type        = string
}

variable "backup_retention" {
  description = "The days to retain backups for"
  default     = 7
  type        = number
}

variable "skip_final_snap" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default     = true
  type        = bool
}

variable "encrypted_db" {
  description = "Specifies whether the DB instance is encrypted."
  default     = true
  type        = bool
}

variable "allow_major_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  default     = false
  type        = bool
}

variable "elb_cert" {
  description = "The ARN of an SSL certificate to be used in ELB"
  default     = ""
  type        = string
}

variable "efs_token" {
  description = "A unique name used as reference when creating the Elastic File System to ensure idempotent file system creation"
  default     = ""
  type        = string
}

variable "ec2_key" {
  description = "Location of PEM to access instance"
  default     = ""
  type        = string
}

variable "environment" {
  description = ""
  default     = ""
  type        = string
}

variable "projectname" {
  description = ""
  default     = ""
  type        = string
}