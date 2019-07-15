#!/bin/bash
set -e

if ! systemctl is-active docker > /dev/null; then
    echo "Docker is not running. Bailing out.."
    exit 1
fi

DATETAG="$(date +%Y%m%d -u)"
REPO="andygabby"

echo "Getting registry credentials"
docker login

git clone https://github.com/letsencrypt/boulder boulder
#git --git-dir ct-woodpecker/.git --work-tree ct-woodpecker checkout ${COMMIT}

GIT_HASH="$(git --git-dir boulder/.git rev-parse --short HEAD)"

echo "Building ct-woodpecker container"
docker build -f ./Dockerfile -t ${REPO}/ocsp_forever:${DATETAG}-${GIT_HASH} ./boulder/.

echo "Pushing containers to the registry"
docker push ${REPO}/ocsp_forever:${DATETAG}-${GIT_HASH}

echo "Cleaning up"
rm -rf boulder
