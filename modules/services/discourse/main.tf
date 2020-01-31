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

// Generate sso_jwt_secret
resource "random_string" "discourse_sso_jwt_secret" {
  length = 64
}

resource "aws_ssm_parameter" "discourse_sso_jwt_secret" {
  name  = "/${var.environment}/services/discourse/sso_jwt_secret"
  type  = "SecureString"
  value = random_string.discourse_sso_jwt_secret.result
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
  user_data              = templatefile("${path.module}/user_data.sh", {})

  tags = {
    Name        = "discourse_${var.environment}"
    Environment = var.environment
    Terraform   = true
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    delete_on_termination = false
  }

  timeouts {
    create = "30m"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }

  /**
   * Provisioners
   */
  provisioner "file" {
    content = templatefile("${path.module}/web.yml", {
      discourse_smtp_port             = var.discourse_smtp_port
      discourse_smtp_username         = var.discourse_smtp_user_name
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

      discourse_s3_region            = aws_s3_bucket.uploads.region
      discourse_s3_access_key_id     = aws_iam_access_key.discourse.id
      discourse_s3_secret_access_key = aws_iam_access_key.discourse.secret
      discourse_s3_bucket            = aws_s3_bucket.uploads.id
      discourse_s3_cdn_url           = "https://${aws_route53_record.cdn.fqdn}"
    })
    destination = "~/web.yml"

    connection {
      user        = "ubuntu"
      port        = "12345"
      timeout     = "1m"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "file" {
    content = templatefile("${path.module}/settings.yml", {
      sso_secret = "${var.discourse_sso_secret}"

      reply_by_email_address = "${var.discourse_reply_by_email_address}"
      pop3_polling_host      = "${var.discourse_pop3_polling_host}"
      pop3_polling_port      = "${var.discourse_pop3_polling_port}"
      pop3_polling_username  = "${var.discourse_pop3_polling_username}"
      pop3_polling_password  = "${var.discourse_pop3_polling_password}"

      ga_universal_tracking_code = "${var.discourse_ga_universal_tracking_code}"

      s3_access_key_id     = "${aws_iam_access_key.discourse.id}"
      s3_secret_access_key = "${aws_iam_access_key.discourse.secret}"
      s3_upload_bucket     = "${aws_s3_bucket.uploads.id}"
      s3_cdn_url           = "https://${aws_route53_record.cdn.fqdn}"

      backup_frequency = "3"
      s3_backup_bucket = "${aws_s3_bucket.backups.id}"
    })
    destination = "~/settings.yml"

    connection {
      user        = "ubuntu"
      port        = "12345"
      timeout     = "1m"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      // Update
      <<-BASH
        sudo apt-get update
      BASH
      ,

      // Enable swap
      <<-BASH
        sudo fallocate -l 2G /swapfile
        ls -lh /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
      BASH
      ,

      // Install Docker
      <<-BASH
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo apt-key fingerprint 0EBFCD88

        repo=https://download.docker.com/linux/ubuntu
        sudo add-apt-repository "deb [arch=amd64] $repo $(lsb_release -cs) stable"
        sudo apt-get update && sudo apt-get install docker-ce -y \
          --no-install-recommends
      BASH
      ,

      // Download Discourse
      <<-BASH
        sudo mkdir -p /opt/discourse
        sudo chown ubuntu.ubuntu /opt/discourse
        git clone https://github.com/discourse/discourse_docker.git /opt/discourse
        mv ~/web.yml /opt/discourse/containers/web.yml
        mv ~/settings.yml /opt/discourse/settings.yml
      BASH
      ,

      // Add ubuntu to the docker user group
      <<-BASH
        sudo usermod -aG docker ubuntu
      BASH
      ,

      // Bootstrap Discourse
      // Allow some time to services come up
      <<-BASH
        cd /opt/discourse
        sudo ./launcher bootstrap web
        sudo ./launcher start web
        sleep 60
      BASH
      ,
    ]

    connection {
      user        = "ubuntu"
      port        = "12345"
      timeout     = "30m"
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "remote-exec" {
    inline = [
      // Copy settings
      <<-BASH
        docker cp /opt/discourse/settings.yml web:/var/www/discourse
        docker exec -w /var/www/discourse web bash -c 'rake site_settings:import < settings.yml'
      BASH
      ,
    ]

    connection {
      user        = "ubuntu"
      port        = "12345"
      timeout     = "30m"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}
