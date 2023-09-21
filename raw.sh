#!/bin/bash

#  Automate Ubuntu 22.04 service restart after app update 
# sed -ie 's/'i'/'a'/' /etc/needrestart/needrestart.conf
# sed -ie 's/#\$nrconf/\$nrconf/' /etc/needrestart/needrestart.conf

#  Update the OS with latest patches and Prerequisites
sudo apt update
sudo apt upgrade -y

#  Install Ubuntu Desktop
sudo apt install -y ubuntu-desktop

#  Install other dev utilities
#  Download and install Termius and Google Chrome
echo "Download and install Termius and Google Chrome"
wget https://www.termius.com/download/linux/Termius.deb
wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i *google*.deb vscode.deb Termius.deb

# Install VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https

# Install aws-cli
echo "Install aws-cli"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Terraform
echo "Install Terraform"
sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Ansible, git-extras and terminator
echo "Install Ansible"
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install git-extras terminator -y

# Finish installing Terraform, VSCode, python3-pip, git, xclip and Terminator
sudo apt-get update 
echo "Finish installing Terraform, VSCode, python3-pip, git, xclip and Terminator"
sudo apt-get install terraform code python3-pip git xclip terminator -y
touch ~/.bashrc
terraform -install-autocomplete

# Install Ansible-lint
echo "Install Ansible-lint"
pip3 install ansible-lint

# Install Linode-cli
pip3 install linode-cli --upgrade && pip3 install boto3

# Install Mailspring email client
sudo snap install mailspring

# Install Joplin notes app
sudo apt install -y libfuse2
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# Add ansible-lint to PATH
echo "\n export PATH=$PATH:/home/ubuntu/.local/bin" >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc

# Cleanup: Delete all .deb files
echo "Delete all .deb files and aws zip file"
rm *.deb awscliv2.zip

# Purge rhythmbox, thunderbird and libreoffice installation
sudo apt purge rhythmbox thunderbird* libreoffice* -y

# Reboot the system
sudo reboot
