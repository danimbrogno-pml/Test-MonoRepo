#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

PACKAGE=$1
PACKAGE_VERSION=$2

cd ./packages/$PACKAGE

#PACKAGE_VERSION="$(awk -F\" '/"version":/ {print $4}' package.json)"

echo "THE PACKAGE IS $PACKAGE"
echo "THE PACKAGE VERSION IS $PACKAGE_VERSION"

IMAGE_COMMIT_TAG="pickmyload/test-$PACKAGE:$CIRCLE_SHA1"
IMAGE_TAG="pickmyload/test-$PACKAGE:$PACKAGE_VERSION"

echo "THE IMAGE TAG IS $IMAGE_TAG"
echo "THE IMAGE COMMIT TAG IS $IMAGE_COMMIT_TAG"

echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_LOGIN --password-stdin

docker build --build-arg PACKAGE_VERSION=$PACKAGE_VERSION --build-arg NPM_TOKEN=$NPM_TOKEN -t $IMAGE_COMMIT_TAG -t $IMAGE_TAG .

docker push $IMAGE_COMMIT_TAG
docker push $IMAGE_TAG


# If container already exists with this tag
# if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect $IMAGE_TAG >/dev/null; then
    
#   echo "skipping build of docker image $1$PACKAGE_VERSION. It already exists."

# else
    
#   echo "building docker image $1$PACKAGE_VERSION"


# fi

docker logout