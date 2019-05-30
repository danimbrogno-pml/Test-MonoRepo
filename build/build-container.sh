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

PACKAGE_VERSION="$(awk -F\" '/"version":/ {print $4}' package.json)"

IMAGE_PACKAGE_VERSION_TAG="pickmyload/test-$PACKAGE:$PACKAGE_VERSION"
IMAGE_CANARY_TAG="pickmyload/test-$PACKAGE:canary"
IMAGE_COMMIT_TAG="pickmyload/test-$PACKAGE:$CIRCLE_SHA1"

echo "THE IMAGE PACKAGE VERSION TAG IS $IMAGE_PACKAGE_VERSION_TAG"
echo "THE IMAGE CANARY TAG IS $IMAGE_CANARY_TAG"
echo "THE IMAGE COMMIT TAG IS $IMAGE_COMMIT_TAG"

deploy () {
    
    echo "building docker image $IMAGE_PACKAGE_VERSION_TAG"

    docker build --build-arg PACKAGE_VERSION=$PACKAGE_VERSION --build-arg NPM_TOKEN=$NPM_TOKEN -t $IMAGE_PACKAGE_VERSION_TAG -t $IMAGE_CANARY_TAG -t $IMAGE_COMMIT_TAG .

    if [ "$IS_CANARY" -eq "1" ]; then
        
        docker push $IMAGE_CANARY_TAG
        docker push $IMAGE_COMMIT_TAG

    else

        docker push $IMAGE_PACKAGE_VERSION_TAG

    fi

}

testExists () {
    DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect $IMAGE_PACKAGE_VERSION_TAG >/dev/null
}

echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_LOGIN --password-stdin

# If we are doing canary release
if [ "$IS_CANARY" -eq "1" ]; then
    deploy
# Or the image does not exist in the repository
elif ! testExists ; then
    deploy
else
    echo "skipping build of docker image $IMAGE_PACKAGE_VERSION_TAG. It already exists."
fi

docker logout