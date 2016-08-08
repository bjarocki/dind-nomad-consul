#!/usr/bin/env bash

set -e

source platforms/variables

if [ ! -f "$URL_FILENAME" ]; then
  echo "please run ./start.sh"
  exit 1
fi

URL="$(cat $URL_FILENAME|head -1)"

if [ -z "$URL" ]; then
  echo "Something is wrong with the running container. I can't see anything inside $URL file"
  exit 1
fi

curl -s $URL$CONSUL_RESERVED_URL/v1/catalog/services|$JQ_COMMAND .
