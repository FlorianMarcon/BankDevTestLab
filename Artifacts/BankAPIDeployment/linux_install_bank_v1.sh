#!/bin/bash

# Check if docker is already installed.
echo "\e[33mInstalling docker\e[0m"
docker -v
installationStatus=$(echo $?)

if [ $installationStatus -eq 127 ] ; then
    wget -qO- https://get.docker.com/ | sh
fi

echo "\e[33mInstalling git\e[0m"
apt-get -y install git

echo  "\e[33mClonning repository\e[0m"
echo "Branch is	" $1
echo "Github Username:	" $2
echo "Personal Access Token:	" $3
git clone --recurse-submodules https://$2:$3@github.com/FlorianMarcon/BankAPI.git --branch $1

cd BankAPI

echo  "\e[33mDownloading .env file\e[0m"
echo ".env uri:	"	$4
wget $4 -O .env

echo  "\e[33mBuilding Image\e[0m"
docker build -t app .

echo  "\e[33mLaunching application\e[0m"
echo "Port:	"	$5
docker run --name=bankapi --restart=always -p $5:80 -d app:latest

echo "\e[32mArtifact finished successfully\e[0m"
exit 0

#sh linux_install_bank_v1.sh master <user> <token> <.envuri> 80
