#!/bin/bash
if [ $1 == '--eval' ]; then
    export RELEASE="eval"
else
    export RELEASE="latest"
fi

make build

docker-compose up -d
