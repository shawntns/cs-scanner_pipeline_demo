#!/bin/bash
#author: xxu@tenable.com
#usage: sh import.sh <regisrtry ip> <registry port>
docker run \
    -e TENABLE_ACCESS_KEY=${TENABLE_ACCESS_KEY}  \
    -e TENABLE_SECRET_KEY=${TENABLE_SECRET_KEY} \
    -e IMPORT_REPO_NAME=import-registry-$(date +'%m-%d-%y') \
    -e REGISTRY_URI=http://$1:$2 \
    -e IMPORT_INTERVAL_MINUTES=1 \
    --rm -d --name import tenableio-docker-consec-local.jfrog.io/cs-scanner:latest import-registry
docker logs import -f