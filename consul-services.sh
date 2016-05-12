#!/usr/bin/env bash

set -e

JQ_COMMAND="$(which jq)"
CONTAINER_IP_FILENAME=".container_ip"

# if you want to change this remember to update etc/consul-templates/nomad-http-service.conf.ctmpl
CONSUL_RESERVED_URL=/8f45d8a9-28b0-4581-bc99-bd58b257b7c9


if [ -z "$JQ_COMMAND" ]; then
  echo "Please install jq by running:"
  echo "OSX: brew install jq"
  echo "ubuntu/debian: apt-get install jq"
  exit 1
fi

if [ ! -f "$CONTAINER_IP_FILENAME" ]; then
  echo "please run ./start.sh"
  exit 1
fi

CONTAINER_IP="$(cat $CONTAINER_IP_FILENAME|head -1)"

if [ -z "$CONTAINER_IP" ]; then
  echo "Something is wrong with the running container. I can't see anything inside $CONTAINER_IP file"
  exit 1
fi

curl -s http://$CONTAINER_IP$CONSUL_RESERVED_URL/v1/catalog/services|$JQ_COMMAND .
