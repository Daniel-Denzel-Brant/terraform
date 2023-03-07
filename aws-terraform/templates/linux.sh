#! /bin/bash
sudo yum update -y

#Docker
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

#Git
sudo yum install git -y

#PowerShell
curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
sudo yum install --assumeyes powershell

sudo pwsh /usr/local/git/docker/docker/scripts/build.ps1
sudo pwsh /usr/local/git/docker/docker/scripts/test-run.ps1