#!/usr/bin/env bash

COMMAND=$1
SCRIPT_PATH=$(realpath "$0")
BASE_DIR=$(dirname "$SCRIPT_PATH")

if [[ -z "$COMMAND" ]]; then
    COMMAND="make"
fi

# clear the output folder, if existing
if [[ -d "$BASE_DIR/build" ]]; then
    rm -rf "$BASE_DIR/build"
    echo "Cleaned the build directory."
fi

# define docker container
SPHINX_IMAGE=registry.blawert.org/misc/docker-compose/sphinx:latest
DOCKER_START="docker run --rm -u $(id -u):$(id -g) -v $BASE_DIR:/var/documentation -it $SPHINX_IMAGE"

function fix_static_links() {
    if [[ -d "$BASE_DIR/build/html" ]]; then
        mv "$BASE_DIR/build/html/_static" "$BASE_DIR/build/html/static" && \
        find "$BASE_DIR/build/html" -type f -exec sed -i 's/_static/static/g' {} \; && \
        echo "Renamed directory _static to static and fixed links within all files."
    fi
}

# and run it with the given command
if [[ "init" == "$COMMAND" ]]; then
    ${DOCKER_START} sphinx-quickstart

elif [[ "make" == "$COMMAND" ]]; then
    ${DOCKER_START} make html
    fix_static_links

elif [[ "release" == "$COMMAND" ]]; then
    ${DOCKER_START} make html
    fix_static_links

    if [[ -d "$BASE_DIR/build/html" ]]; then
        if [[ -d "$BASE_DIR/docs" ]]; then
            rm -rf "$BASE_DIR/docs"
            echo "Cleaned the output directory."
        fi

        cp -r "$BASE_DIR/build/html" "$BASE_DIR/docs"
        echo "Copied the /build/html directory to /docs"
    fi

elif [[ "bash" == "$COMMAND" ]]; then
    ${DOCKER_START} bash

else
    echo "Unknown command $COMMAND"
    exit 1
fi

exit 0
