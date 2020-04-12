#!/usr/bin/env bash

DOCKER_USER=www-data
PROJECT_NAME=$(basename $(pwd) | tr  '[:upper:]' '[:lower:]')
PHP_SERVICE=zf

copyHostData() {

    mkdir -p utils/php/git/
    cp ~/.gitconfig utils/php/git/

    if [[ ! -d utils/php/ssh ]]; then
        mkdir -p utils/php/ssh
        cp ~/.ssh/id_rsa utils/php/ssh/
        cp ~/.ssh/id_rsa.pub utils/php/ssh/
    fi
}

if [[ "$1" = "composer" ]]; then

    shift 1
    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        run \
        --rm \
        -u ${DOCKER_USER} \
        -v ${PWD}:/var/www/app \
        ${PHP_SERVICE} \
        composer $@

elif [[ "$1" = "up" ]]; then

    shift 1

    copyHostData

    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        up $@

elif [[ "$1" = "build" ]]; then

    shift 1

    copyHostData

    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        build $@

elif [[ "$1" = "enter-root" ]]; then

    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        exec \
        -u root \
        ${PHP_SERVICE} /bin/bash

elif [[ "$1" = "enter" ]]; then

    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        exec \
        -u ${DOCKER_USER}  \
        ${PHP_SERVICE} /bin/zsh

elif [[ "$1" = "enter-utente" ]]; then

    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        exec \
        -u utente  \
        ${PHP_SERVICE} /bin/zsh

elif [[ "$1" = "down" ]]; then

    shift 1
    docker-compose \
      --file docker-compose.yml \
      -p ${PROJECT_NAME} \
    down $@

elif [[ "$1" = "purge" ]]; then

    docker-compose \
      --file docker-compose.yml \
      -p ${PROJECT_NAME} \
    down \
        --rmi=all \
        --volumes \
        --remove-orphans

elif [[ "$1" = "log" ]]; then

    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        logs -f

elif [[ $# -gt 0 ]]; then
    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        "$@"

else
    docker-compose \
        --file docker-compose.yml \
        -p ${PROJECT_NAME} \
        ps
fi
