#!/bin/bash

# Check if docker is already installed.
echo "\e[33mInstalling docker\e[0m"
docker -v
installationStatus=$(echo $?)

if [ $installationStatus -eq 127 ] ; then
    wget -qO- https://get.docker.com/ | sh
fi

docker-compose -v
installationStatus=$(echo $?)

if [ $installationStatus -eq 127 ] ; then
    # Install docker-compose
    COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
    sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
    chmod +x /usr/local/bin/docker-compose
    sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
fi


echo "\e[33mInstalling git\e[0m"
apt-get -y install git

echo  "\e[33mClonning repository\e[0m"
echo "Branch is	" $1
echo "Github Username:	" $2
echo "Personal Access Token:	" $3
git clone --recurse-submodules https://$2:$3@github.com/FlorianMarcon/CadeoDockerComposeDeployment.git --branch $1

# echo  "\e[33mDownloading .env file\e[0m"
echo "Mode:	"	$4
cd CadeoDockerComposeDeployment
cd $4

echo "\e[33mLaunching script to start docker compose in folder $pwd\e[0m"
chmod +x "./init-letsencrypt.sh"
./init-letsencrypt.sh

initStatus=$(echo $?)
if [ $initStatus -ne 0 ] ; then
    echo "Error while lets encrypt initialisation"
    exit 42
fi

echo "\e[32mArtifact finished successfully\e[0m"
exit 0

