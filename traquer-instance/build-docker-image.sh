#!/bin/sh

# Build image with docker
# docker build --build-arg WHEN=2019-02-24 -t stream-techs/predict-accident-r:v1 .

# Build image with docker-compose
# docker-compose build --no-cache --build-arg WHEN=2019-02-24
#exit 0
docker-compose build --build-arg HOST_USER_ID=$(id -u) \
                     --build-arg HOST_GROUP_ID=$(id -g) \
                     --build-arg HOST_GROUP_NAME=$(id -gn)
