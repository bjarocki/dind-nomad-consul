#!/usr/bin/env bash

set -e

JQ_COMMAND="$(which jq)"
CONTAINER_IP_FILENAME=".container_ip"

if [ -z "$JQ_COMMAND" ]; then
  echo "Please install jq by running:"
  echo "OSX: brew install jq"
  echo "ubuntu/debian: apt-get install jq"
  exit 1
fi

if [ $# -gt 1 ]; then
  NODE_NAME=$1
else
  NODE_NAME=nt-local-dev
fi

CONTAINER_ID="$(sudo docker run -d --privileged --name $NODE_NAME docker-registry.service.consul/nt-local-dev)"
CONTAINER_IP="$(sudo docker inspect $CONTAINER_ID|jq -r .[].NetworkSettings.Networks.bridge.IPAddress)"

echo -n "$CONTAINER_IP" > $CONTAINER_IP_FILENAME

# let me remove the old public key from know hosts so you don't get annoyed by ssh errors
if [ -f "$HOME/.ssh/known_hosts" ]; then
  ssh-keygen -q -f "$HOME/.ssh/known_hosts" -R 172.17.0.2 1>&2> /dev/null
fi

echo
echo
echo "Your container is ready \\o/"
echo "IMPORTANT: Wait until ./consul-services.sh respond with some services"
echo
echo "Now nomad is getting docker images necessary to run jobs defined in ./nomad-jobs directory"
echo "This might get few minutes depending on your networking connection"
echo "If you want to get there and look around run:"
echo "ssh root@$CONTAINER_IP"
echo "root password: nowthis"
echo
echo "If you're looking for a pitches API try this:"
echo "list pitches: curl -s http://$CONTAINER_IP/queries/pitches"
echo "create a pitch: curl -s -XPOST -H \"Content-Type:application/x-www-form-urlencoded\" -H \"Accept:application/json\" -d \"title=Man on the Moon.\" -d \"id=666\" \"http://$CONTAINER_IP/commands/create_pitch\""
echo
echo "Slack @bartek.jarocki if you need help."
