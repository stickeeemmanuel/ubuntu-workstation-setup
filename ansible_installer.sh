#!/bin/bash
# Installing Ansible
echo "Installing Ansible"
sudo apt -y install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y