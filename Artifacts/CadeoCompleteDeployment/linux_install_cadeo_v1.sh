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

if [ "$1" == "production" ] ; then
    echo "Mode is Production"
    cd production
    # domains=(www.cartt.fr cartt.fr www.api.cartt.fr api.cartt.fr)
elif [ "$1" == "development" ] ; then
    echo "Mode development not yet implemented"
    exit 42
else
    exit 42
fi
echo "\e[33mLaunching script to start docker compose in folder $folder\e[0m"
chmod +x "./init-letsencrypt.sh"
./init-letsencrypt.sh

echo "\e[32mArtifact finished successfully\e[0m"
exit 0

