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
git clone --recurse-submodules https://$2:$3@github.com/marcfrezal/Cadeo_Front_Web.git --branch $1

if [ $? -ne 0 ] ; then
    echo  "\e[33mUne erreur est survenue durant le clonage du dépot\e[0m"
    exit 42
fi

cd Cadeo_Front_Web

echo  "\e[33mDownloading .env file\e[0m"
echo ".env uri:	"	$4
wget $4 -O .env

echo  "\e[33mBuilding Image\e[0m"
docker build -t cadeo-landing-$5 .

echo "\e[32mArtifact finished successfully\e[0m"
exit $?

