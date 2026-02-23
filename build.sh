#!/bin/bash

# Import the .env file vars
set -a
source .env
set +a

# Allows the user to specify the dockerfile to use
dockfile=Dockerfile
if [ $# -ge 1 ]; then
  dockfile=$1
fi

# Downloads the latest Minecraft server
rm -rf ./build
mkdir ./build
./latest_mc.sh build/server.jar

# Pre-create the directory structure and world folder
mkdir -p "$DOCKERDATA/minecraft/$SERVER_NAME/world"

# Create several files needed to bind / save to later.
touch "$DOCKERDATA/minecraft/$SERVER_NAME/server.properties"
touch "$DOCKERDATA/minecraft/$SERVER_NAME/ops.json"
touch "$DOCKERDATA/minecraft/$SERVER_NAME/whitelist.json"

echo '[]' > "$DOCKERDATA/minecraft/$SERVER_NAME/ops.json"
echo '[]' > "$DOCKERDATA/minecraft/$SERVER_NAME/whitelist.json"

docker build -t minecraft-server -f $dockfile .