#!/bin/sh

set -ex

echo "==> Maven repo"
ls ~/.m2/repository/ 2>/dev/null || echo "No maven cache"

echo "==> Maven local"
ls /usr/local/maven/ 2>/dev/null || echo "No /usr/local/maven"

if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    echo "Building push"
    mvn test -B
else
    echo "Building pull"
    PROJECTS=$(git diff ${TRAVIS_PULL_REQUEST_BRANCH}..HEAD --name-only | grep '/' | sed -e 's/^\([^\/]*\)\/.*$/\1/' | sort | uniq | awk 'BEGIN{ORS=","}; {print $1}')
    mvn test -B -amd -am -pl ${PROJECTS}
fi
