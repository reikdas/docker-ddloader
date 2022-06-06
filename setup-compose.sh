#!/bin/bash
export RELEASE="latest"

make build

docker-compose up -d
