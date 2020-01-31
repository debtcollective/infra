#!/bin/bash
# Change SSH Port to 12345
perl -pi -e 's/^#?Port 22$/Port 12345/' /etc/ssh/sshd_config
service sshd restart || service ssh restart

# Add ssh keys for root user (/root/.ssh/authorized_keys)
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNmbm3AR92kE0igfVUJ9ZpY48oVS4Po+qH/3Jb6gF5NkHju+67Rf2MDkWQ4NzNp9yjlxL7LQk7c0dNuIR++GSS6dOLxixPXnLcYadqJF2h5qPV8RMNkOTuHR/zWPPEh77Xur8NoFtroBaCEMulfmGNUauyaNcV/KoK4/lxN53JItJaUt7OzdMU12jOdLsN985Neu2rPVIFv3eYty/rSEtTWkmIwVvVXkpFzoRTuNM+hYTPiAniHiON/h+wfNG5Ei4Lu/dGhy0NZRavF9TQTvLv/vsXQta6q+HzvF4IYsj2Dt0YBvNNL/uyO4mfA08U0jjnJCh7sjIHHrju9Q/i6r2sjNOoiynDnorUXAlUn++gkyFlksnRMLTxAKgvwYVsiQMjoOdIacp3Xwn11BaO6VsGf/9ub+P9B5XbG6gfwtVEWaag2FkWuIeFLF6qMwMAqpZFSG+lFO0iqFwxTO7MnwRTDxmiE13tfl3QHdciTc+qjtnNEPIhbJR0pQmtwZnnOmFdrxcb8phwdZOvUFA0OSXEL0VwvM6NaORpVxfotdWyZJ/JIhv1Jre0h+folgd1FIuNjZ7dVGQvbEwwVZDbsPHZNKbacHjD/sj9sK+rEll1RKTS8ReDBPWek1aoA9V80FSV6aMtI4/pVOXP6/1CBYEgB4nzZUBlzlS3uiCx9C6s4Q== orlando@hashlabs.com" >> /root/.ssh/authorized_keys

# Add ssh keys for ubuntu user (/home/ubuntu/.ssh/authorized_keys)
mkdir -p /home/ubuntu/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNmbm3AR92kE0igfVUJ9ZpY48oVS4Po+qH/3Jb6gF5NkHju+67Rf2MDkWQ4NzNp9yjlxL7LQk7c0dNuIR++GSS6dOLxixPXnLcYadqJF2h5qPV8RMNkOTuHR/zWPPEh77Xur8NoFtroBaCEMulfmGNUauyaNcV/KoK4/lxN53JItJaUt7OzdMU12jOdLsN985Neu2rPVIFv3eYty/rSEtTWkmIwVvVXkpFzoRTuNM+hYTPiAniHiON/h+wfNG5Ei4Lu/dGhy0NZRavF9TQTvLv/vsXQta6q+HzvF4IYsj2Dt0YBvNNL/uyO4mfA08U0jjnJCh7sjIHHrju9Q/i6r2sjNOoiynDnorUXAlUn++gkyFlksnRMLTxAKgvwYVsiQMjoOdIacp3Xwn11BaO6VsGf/9ub+P9B5XbG6gfwtVEWaag2FkWuIeFLF6qMwMAqpZFSG+lFO0iqFwxTO7MnwRTDxmiE13tfl3QHdciTc+qjtnNEPIhbJR0pQmtwZnnOmFdrxcb8phwdZOvUFA0OSXEL0VwvM6NaORpVxfotdWyZJ/JIhv1Jre0h+folgd1FIuNjZ7dVGQvbEwwVZDbsPHZNKbacHjD/sj9sK+rEll1RKTS8ReDBPWek1aoA9V80FSV6aMtI4/pVOXP6/1CBYEgB4nzZUBlzlS3uiCx9C6s4Q== orlando@hashlabs.com" >> /home/ubuntu/.ssh/authorized_keys

# Know Hosts
ssh-keyscan -H 'github.com' >> $HOME/.ssh/known_hosts

##
## DISCOURSE INSTALLATION
##
# update package list
sudo apt-get update

# enable swap
sudo fallocate -l 4G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

# install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

repo=https://download.docker.com/linux/ubuntu
sudo add-apt-repository "deb [arch=amd64] $repo $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install docker-ce -y \
  --no-install-recommends

# add ubuntu to docker group
sudo usermod -aG docker ubuntu

# install discourse
sudo mkdir -p /opt/discourse
sudo chown ubuntu.ubuntu /opt/discourse
git clone https://github.com/discourse/discourse_docker.git /opt/discourse
mv ~/web.yml /opt/discourse/containers/web.yml
mv ~/settings.yml /opt/discourse/settings.yml

# bootstrap discourse
# sleep 60 to give some time for services to come up
cd /opt/discourse
sudo ./launcher bootstrap web
sudo ./launcher start web
sleep 60
