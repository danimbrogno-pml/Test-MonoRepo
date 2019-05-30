#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

cd ./packages/$1

PACKAGE_VERSION="$(awk -F\" '/"version":/ {print $4}' package.json)"

IMAGE_TAG="pickmyload/test-$1:next"

echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_LOGIN --password-stdin

docker build --build-arg PACKAGE_VERSION=$PACKAGE_VERSION --build-arg NPM_TOKEN=$NPM_TOKEN -t $IMAGE_TAG .

docker push $IMAGE_TAG

# If container already exists with this tag
# if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect $IMAGE_TAG >/dev/null; then
    
#   echo "skipping build of docker image $1$PACKAGE_VERSION. It already exists."

# else
    
#   echo "building docker image $1$PACKAGE_VERSION"


# fi

docker logout