#!/bin/sh

# With docker
#docker run --name predict-accident-r -itd -p 8787:8787 -e USER=username -e PASSWORD=password stream-techs/predict-accident-r:v1

# With docker-compose
docker compose --compatibility up --force-recreate
