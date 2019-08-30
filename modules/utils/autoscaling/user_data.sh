#!/bin/bash
# Register instance with ECS cluster
echo ECS_CLUSTER=${cluster_name} > /etc/ecs/ecs.config
export ENVIRONMENT=${environment}

# Change SSH Port to 12345
sudo sed -i 's/#Port 22$/Port 12345/' /etc/ssh/sshd_config
sudo service sshd restart || sudo service ssh restart

# Tools
sudo yum install htop -y

# Create swap file
sudo fallocate -l 1G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf