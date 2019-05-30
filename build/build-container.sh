#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

PACKAGE=$1
PACKAGE_DIST_TAG=$2

cd ./packages/$PACKAGE

PACKAGE_TAG="$(awk -F\" '/"version":/ {print $4}' package.json)"

echo "THE PACKAGE IS $PACKAGE"
echo "THE PACKAGE VERSION IS $PACKAGE_TAG"
echo "THE PACKAGE DIST TAG IS $PACKAGE_DIST_TAG"

IMAGE_TAG="pickmyload/test-$PACKAGE:$PACKAGE_TAG"
IMAGE_DIST_TAG="pickmyload/test-$PACKAGE:$PACKAGE_DIST_TAG"

echo "THE IMAGE TAG IS $IMAGE_DIST_TAG"
echo "THE IMAGE COMMIT TAG IS $IMAGE_TAG"

echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_LOGIN --password-stdin


# If container already exists with this tag
if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect $IMAGE_TAG >/dev/null; then
    
  echo "skipping build of docker image $IMAGE_TAG. It already exists."

else
    
    echo "building docker image $IMAGE_TAG"
    docker build --build-arg PACKAGE_TAG=$PACKAGE_TAG --build-arg NPM_TOKEN=$NPM_TOKEN -t $IMAGE_TAG -t $IMAGE_DIST_TAG .

    docker push $IMAGE_TAG
    docker push $IMAGE_DIST_TAG


fi

docker logout