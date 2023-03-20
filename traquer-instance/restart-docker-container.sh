#!/bin/sh

# With docker
# docker restart predict-accident-r 

# With docker-compose
#docker-compose --compatibility up --force-recreate # if want to recreate the container
# docker-compose --compatibility up -d # if want to run as daemon
docker-compose --compatibility up
