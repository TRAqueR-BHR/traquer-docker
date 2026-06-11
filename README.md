# traquer-docker

TRAQUER can be installed using docker-compose. This is the recommended way for development
and it is also also a viable option for production.

The overall stack is the following:
  - A web frontend provided by an angular app (https://github.com/TRAqueR-BHR/traquer-frontend-angular)
  and served by an nginx server
  - A backend provided by a julia project (https://github.com/TRAqueR-BHR/TRAQUER.jl)
  - A postgresql database

All three components are glued together by the docker compose project https://github.com/TRAqueR-BHR/traquer-docker

## Prerequisite: Install docker and docker-compose if not already installed

https://docs.docker.com/compose/install/

## Clone Traquer repositories

Clone the following repositories:
  - https://github.com/TRAqueR-BHR/TRAQUER.jl
  - https://github.com/TRAqueR-BHR/traquer-frontend-angular
  - https://github.com/TRAqueR-BHR/traquer-docker


### Tweak traquer-docker

#### Create the .env file

  * `cp dot-env.tpl .env`
  * Modify the path in .env

#### Create the .pgpass file at `volumes/julia-server/.pgpass`
This allows traquer scheduler to `pg_dump`
Here is the content of the file:
```
traquer-postgresql-16-server:5432:*:traquer_dev:traquer_dev
```

#### Copy the files from the host (Needed for remote dev)
  * `cp ~/.ssh/id_* dockerfiles/docker-build-assets/files-from-host-user/`
  * `cp ~/.gitconfig dockerfiles/docker-build-assets/files-from-host-user/`

#### Create the authorized_keys
For ssh development, it allows users not to have to give the password
`touch dockerfiles/docker-build-assets/files-from-host-user/authorized_keys`
and copy the public key of your host:
eg. `cat ~/.ssh/id_rsa.pub >> dockerfiles/docker-build-assets/files-from-host-user/authorized_keys`


### Create the key for signing JWT

  * `cp volumes/julia-server/jwt_signing_keys.json.tpl volumes/julia-server/jwt_signing_keys.json`
  * Generate a HS256 string (see volumes/julia-server/README.md) and replace it in jwt_signing_keys.json

### Build and run
See the following scripts:
  - build-docker-image.sh
  - run-docker-container.sh
  - restart-docker-container.sh

Once started you should see as many containers as services declared in docker-compose.yaml


### Tweak the julia backend

#### Create the config file for TRAQUER.jl

`cp TRAQUER.jl/conf/tpl.conf TRAQUER.jl/conf/whatever_name_you_want.conf`

#### Create startup.jl and reference the config file you just created

  * `cp volumes/julia-server/.julia/config/startup.jl.tpl volumes/julia-server/.julia/config/startup.jl`
  * `vi volumes/julia-server/.julia/config/startup.jl`

At this point, from the julia container, you should be able to start a julia session and run
`using TRAQUER`

### Create the PostreSQL database and initialize it

#### Add User and DB with template0 so that we can restore a dump from a database with a different name
```
CREATE USER <your_user> WITH PASSWORD 'your_password'
CREATE DATABASE <your_database_name> TEMPLATE template0 OWNER <your_user>;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
```

#### Initialize the database with an existing database

Use julia script in TRAQUER.jl `scripts/backup-restore-dev-database/restore-dev-database.jl`

### Tweak the angular frontend

See src/environments

At this point you should be able to run the angular app with `ng serve` and see the frontend at http://localhost:4200
or build it for deployment

#### Create nginx config file (not needed for dev)

  * `cp volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf.tpl volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf`
  * `vi volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf`

NOTE: Don't forget to modify the server_name
