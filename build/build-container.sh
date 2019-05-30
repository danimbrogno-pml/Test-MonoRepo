#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

PACKAGE=$1
IS_CANARY=$2

cd ./packages/$PACKAGE

if [ "$IS_CANARY" -eq "1" ]; then
    PACKAGE_VERSION="canary"
else
    PACKAGE_VERSION="$(awk -F\" '/"version":/ {print $4}' package.json)"
fi

IMAGE_TITLE="$PACKAGE:$PACKAGE_VERSION"
IMAGE_PACKAGE_VERSION_TAG="pickmyload/test-$PACKAGE:$PACKAGE_VERSION"
IMAGE_COMMIT_TAG="pickmyload/test-$PACKAGE:$CIRCLE_SHA1"

echo "THE IMAGE PACKAGE VERSION TAG IS $IMAGE_PACKAGE_VERSION_TAG"
echo "THE IMAGE COMMIT TAG IS $IMAGE_COMMIT_TAG"

echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_LOGIN --password-stdin

echo "building docker image $IMAGE_TITLE"

docker build --build-arg PACKAGE_VERSION=$PACKAGE_VERSION --build-arg NPM_TOKEN=$NPM_TOKEN -t $IMAGE_PACKAGE_VERSION_TAG -t $IMAGE_COMMIT_TAG .

docker push $IMAGE_COMMIT_TAG
docker push $IMAGE_PACKAGE_VERSION_TAG

docker logout