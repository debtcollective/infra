// Generate sso_jwt_secret
resource "random_string" "discourse_sso_jwt_secret" {
  length = 64
}

resource "aws_ssm_parameter" "discourse_sso_jwt_secret" {
  name      = "/${var.environment}/services/discourse/sso_jwt_secret"
  type      = "SecureString"
  value     = random_string.discourse_sso_jwt_secret.result
  overwrite = true
}

// ec2 instance
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

resource "aws_eip" "discourse" {
  instance = aws_instance.discourse.id
  vpc      = true
}

resource "aws_instance" "discourse" {
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_groups]
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = var.subnet_id
  user_data = templatefile("${path.module}/cloud-config.yml", {
    # web.yml file
    web_yml_b64 = base64encode(
      templatefile("${path.module}/web.yml", {
        discourse_smtp_port             = var.discourse_smtp_port
        discourse_smtp_username         = var.discourse_smtp_username
        discourse_smtp_password         = var.discourse_smtp_password
        discourse_smtp_address          = var.discourse_smtp_address
        discourse_smtp_enable_start_tls = var.discourse_smtp_enable_start_tls
        discourse_smtp_authentication   = var.discourse_smtp_authentication

        discourse_db_host     = var.discourse_db_host
        discourse_db_port     = var.discourse_db_port
        discourse_db_name     = var.discourse_db_name
        discourse_db_username = var.discourse_db_username
        discourse_db_password = var.discourse_db_password

        discourse_developer_emails          = var.discourse_developer_emails
        discourse_hostname                  = var.discourse_hostname
        discourse_maxmind_license_key       = var.discourse_maxmind_license_key
        discourse_letsencrypt_account_email = var.discourse_letsencrypt_account_email
        discourse_sso_jwt_secret            = aws_ssm_parameter.discourse_sso_jwt_secret.value
        discourse_sso_cookie_name           = "tdc_auth_${var.environment}"
        discourse_sso_cookie_domain         = ".${var.domain}"

        discourse_s3_region            = var.discourse_uploads_bucket_region
        discourse_s3_access_key_id     = var.discourse_aws_access_key_id
        discourse_s3_secret_access_key = var.discourse_aws_secret_access_key
        discourse_s3_upload_bucket     = var.discourse_uploads_bucket_name
        discourse_s3_backup_bucket     = var.discourse_backups_bucket_name
        discourse_s3_cdn_url           = var.cdn_url
      })
    )

    # settings.yml file
    settings_yml_b64 = base64encode(
      templatefile("${path.module}/settings.yml", {
        sso_secret = var.discourse_sso_secret

        reply_by_email_address = var.discourse_reply_by_email_address
        pop3_polling_host      = var.discourse_pop3_polling_host
        pop3_polling_port      = var.discourse_pop3_polling_port
        pop3_polling_username  = var.discourse_pop3_polling_username
        pop3_polling_password  = var.discourse_pop3_polling_password

        ga_universal_tracking_code = var.discourse_ga_universal_tracking_code

        s3_access_key_id     = var.discourse_aws_access_key_id
        s3_secret_access_key = var.discourse_aws_secret_access_key
        s3_upload_bucket     = var.discourse_uploads_bucket_name
        s3_cdn_url           = var.cdn_url

        backup_frequency = "3"
        s3_backup_bucket = var.discourse_backups_bucket_name
      })
    )
  })

  tags = {
    Name        = "discourse_${var.environment}"
    Environment = var.environment
    Terraform   = true
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"

    delete_on_termination = false
  }

  lifecycle {
    ignore_changes = [user_data, ami]
  }
}
