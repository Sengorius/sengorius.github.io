#!/usr/bin/env bash

COMMAND=$1
CURRENT_DIR=`pwd`

if [[ -z "$COMMAND" ]]; then
    COMMAND="make"
fi

# clear the output folder, if existing
if [[ -d "$CURRENT_DIR/docs/build" ]]; then
    rm -rf ${CURRENT_DIR}/docs/build/*
    echo "Cleaned the build directory."
fi

# define docker container
SPHINX_IMAGE=sengorius/sphinx:3
DOCKER_START="docker run --rm -u $(id -u):$(id -g) -v $CURRENT_DIR/docs:/var/documentation -it $SPHINX_IMAGE"

# and run it with the given command
if [[ "init" == "$COMMAND" ]]; then
    ${DOCKER_START} sphinx-quickstart
elif [[ "make" == "$COMMAND" ]]; then
    ${DOCKER_START} make html
elif [[ "release" == "$COMMAND" ]]; then
    ${DOCKER_START} make html

    if [[ -d "$CURRENT_DIR/docs/build/html" ]]; then
        if [[ -d "$CURRENT_DIR/docs/docs" ]]; then
            rm -rf ${CURRENT_DIR}/docs/docs
            echo "Cleaned the output directory."
        fi

        cp -r "$CURRENT_DIR/docs/build/html" "$CURRENT_DIR/docs/docs"
        echo "Copied the /build/html directory to /docs"
    fi
elif [[ "bash" == "$COMMAND" ]]; then
    ${DOCKER_START} bash
else
    echo "Unknow command $COMMAND"
    exit 1
fi

exit 0
