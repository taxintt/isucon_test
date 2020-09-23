#!/bin/bash
# usage: cat ./gce_init.sh | ssh isucon-{bench,web,mysql} /bin/bash
# https://kavo.hatenablog.jp/entry/2020/06/27/203500

set -Ceu

# change shell
chsh -s /bin/bash
sudo chsh -s /bin/bash

# install tools (vim, git, htop, dstat)
## https://github.com/htop-dev/htop/
sudo apt-get update
sudo apt-get install -y vim git htop dstat

# install tools (alp)
# http://kazuki229.hatenablog.com/entry/2017/09/29/003314
wget https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip
sudo apt-get install unzip
unzip alp_linux_amd64.zip
sudo mv alp /usr/local/bin/alp
sudo chown root:root /usr/local/bin/alp

# set editor (vim)
# sudo update-alternatives --set editor /usr/bin/vim.basic

# add path to bash profile 
echo "export GOPATH=$HOME/go" >> ~/.bash_profile
source ~/.bash_profile

# set timezone
timedatectl set-timezone Asia/Tokyo

# send pub key
# cat << _EOS > /tmp/authorized_keys
# <cat ~/.ssh/id_isucon9.pub>
# _EOS
# sudo cat /home/isucon/.ssh/authorized_keys >> /tmp/authorized_keys
# sudo mkdir -p /home/isucon/.ssh
# sudo mv /tmp/authorized_keys /home/isucon/.ssh/
# sudo chown -R isucon.isucon /home/isucon/.ssh/
# sudo chmod 600 /home/isucon/.ssh/authorized_keys

# Create mysql dump
# mysqldump -uroot --all-databases > /tmp/mysql.dump

# install isucon9 service +α
sudo apt-get install -y gcc make unzip golang mysql-server mysql-client
go get -u github.com/go-sql-driver/mysql
go get -u github.com/gorilla/sessions

# install docker for initializing data
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

# install and initialize data
go get -d github.com/isucon/isucon9-qualify
cd $GOPATH/src/github.com/isucon/isucon9-qualify/initial-data
make

# initialize database
cd ./../webapp/sql
cat 00_create_database.sql | mysql 
./init.sh