#!/bin/bash
echo "Generating config"
./gen_config.sh

docker-compose -f docker-compose-client.yml up -d