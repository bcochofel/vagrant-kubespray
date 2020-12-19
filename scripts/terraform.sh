#!/bin/bash

# remove terraform binary if exists
sudo rm -f /usr/local/bin/terraform

# install terraform
#LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' | sort -V | tail -n1)
#wget -q $LATEST_URL -O terraform.zip

TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip
wget -q $TERRAFORM_URL -O terraform.zip

sudo mkdir -p /usr/local/bin
sudo unzip terraform.zip -d /usr/local/bin

mkdir ~/bin

exit 0
