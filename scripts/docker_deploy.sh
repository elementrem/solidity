#!/usr/bin/env sh

set -e

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
version=$(grep -oP "PROJECT_VERSION \"?\K[0-9.]+(?=\")"? $(dirname "$0")/../CMakeLists.txt)
if [ "$TRAVIS_BRANCH" = "develop" ]
then
    docker tag elementrem/solc:build elementrem/solc:nightly;
    docker tag elementrem/solc:build elementrem/solc:nightly-"$version"-"$TRAVIS_COMMIT"
    docker push elementrem/solc:nightly-"$version"-"$TRAVIS_COMMIT";
    docker push elementrem/solc:nightly;
elif [ "$TRAVIS_BRANCH" = "release" ]
then
    docker tag elementrem/solc:build elementrem/solc:stable;
    docker push elementrem/solc:stable;
elif [ "$TRAVIS_TAG" = v"$version" ]
then
    docker tag elementrem/solc:build elementrem/solc:"$version";
    docker push elementrem/solc:"$version";
else
    echo "Not publishing docker image from branch $TRAVIS_BRANCH or tag $TRAVIS_TAG"
fi
