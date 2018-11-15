#!/bin/bash

docker-machine create -d virtualbox --virtualbox-memory "2048" --virtualbox-cpu-count "4" default

docker_run=$(docker-machine ls | grep default)
echo $docker_run

if [[ "$docker_run" == *"Saved"* ]] || [[ "$docker_run" == *"Stopped"* ]]
then
    docker-machine start default
    docker-machine-nfs default
    docker-machine env default
    eval "$(docker-machine env default)"
elif [[ "$docker_run" == *"Running"* ]]
then
    docker-machine-nfs default
    docker-machine env default
    eval "$(docker-machine env default)"
fi

UID_VAR="{{ UID_VALUE }}"
UID_VALUE=$(id -u)
if [ $(id -u) -eq 0 ]; then
    echo "please run docker as your user, current user $USER"
    exit 1
fi

GID_VAR="{{ GID_VALUE }}"
GID_VALUE=$(id -g)
if [ $(id -g) -eq 0 ]; then
    echo "please run docker as your user, current user $USER"
    exit 1
fi

# output
echo ${UID_VAR} = ${UID_VALUE}
echo ${GID_VAR} = ${GID_VALUE}


# find and replace
sed -e "s/${UID_VAR}/${UID_VALUE}/g" \
    -e "s/${GID_VAR}/${GID_VALUE}/g" \
    < docker-compose-mac.tpl \
    > docker-compose.yml

docker-compose up -d

echo "done"

