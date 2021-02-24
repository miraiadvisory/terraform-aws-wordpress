## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) |
| [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) |
| [aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) |
| [aws_efs_file_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) |
| [aws_efs_mount_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) |
| [aws_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) |
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| [aws_load_balancer_listener_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_listener_policy) |
| [aws_load_balancer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/load_balancer_policy) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_major\_upgrade | Indicates that major version upgrades are allowed | `bool` | `false` | no |
| backup\_retention | The days to retain backups for | `number` | `7` | no |
| db\_engine | The database engine | `string` | `"mysql"` | no |
| db\_engine\_version | The database engine version | `string` | `"5.7"` | no |
| db\_hostname | (Optional, Forces new resource) The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier | `string` | `""` | no |
| db\_instance\_type | The RDS instance class | `string` | `""` | no |
| db\_name | The name of the database to create when the DB instance is created | `string` | `""` | no |
| db\_parameter\_group | Name of the DB parameter group to associate | `string` | `"default.mysql5.7"` | no |
| db\_storage | The allocated storage in gibibytes | `number` | `20` | no |
| db\_storage\_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD) | `string` | `"gp2"` | no |
| db\_username | Username for the master DB user | `string` | `""` | no |
| db\_userpass | Password for the master DB user | `string` | `""` | no |
| dns\_zone | The Hosted Zone id of the desired Hosted Zone | `string` | `""` | no |
| ec2\_key | Location of PEM to access instance | `string` | `""` | no |
| efs\_token | A unique name used as reference when creating the Elastic File System to ensure idempotent file system creation | `string` | `""` | no |
| elb\_cert | The ARN of an SSL certificate to be used in ELB | `string` | `""` | no |
| encrypted\_db | Specifies whether the DB instance is encrypted. | `bool` | `true` | no |
| environment | Tag | `string` | `""` | no |
| instance\_name | Name Tag for web server instance | `string` | `""` | no |
| instance\_type | The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance. | `string` | `""` | no |
| key\_name | AWS Key to assign to instance | `string` | `""` | no |
| projectname | Tag | `string` | `""` | no |
| pub\_subnet\_1 | First VPC public subnet ID, used to populate aws\_elb.subnets | `string` | `""` | no |
| pub\_subnet\_2 | Second VPC public subnet ID, used to populate aws\_elb.subnets | `string` | `""` | no |
| pub\_subnet\_3 | Third VPC public subnet ID, used to populate aws\_elb.subnets | `string` | `""` | no |
| skip\_final\_snap | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | `true` | no |
| subnet\_id\_1 | The VPC private subnet ID in which to launch the EC2 instance | `string` | `""` | no |
| subnet\_id\_2 | Second VPC private subnet ID, used to populate aws\_db\_subnet\_group.subnet\_ids | `string` | `""` | no |
| subnet\_id\_3 | Third VPC private subnet ID, used to populate aws\_db\_subnet\_group.subnet\_ids | `string` | `""` | no |
| vpc\_id | The VPC ID | `string` | `""` | no |
| wordpress\_db\_sg | List of security group IDs to be given MySQL access | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| wordpress\_web\_http\_sg | List of security group IDs to be given HTTP access | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| wordpress\_web\_https\_sg | List of security group IDs to be given HTTPS access | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| wordpress\_web\_ssh\_sg | List of security group IDs to be given SSH access | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| elb\_sg | n/a |
| wordpress\_web\_sg | n/a |
