# Install TRAQUER

## HOWTO Set up a VM for appli

### Create user traquer_prod (not needed for dev env)

### Install/Enable ufw (not needed for dev env)
```
sudo apt-get install ufw
sudo ufw enable
```

### Install docker and docker-compose

https://docs.docker.com/compose/install/

### Install the instance of traquer

#### Clone traquer-docker and create the configuration

##### Create the .env file

  * `cp traquer-instance/dot-env.tpl traquer-instance/.env`
  * Modify the path in .env

##### Create the .pgpass file
This allows traquer scheduler to `pg_dump`

##### Copy the files from the host (Needed for remote dev)
  * `cp ~/.ssh/id_rsa.pub dockerfiles/docker-build-assets/files-from-host-user/`
  * `cp ~/.ssh/id_rsa dockerfiles/docker-build-assets/files-from-host-user/`
  * `cp ~/.gitconfig dockerfiles/docker-build-assets/files-from-host-user/`

##### Create the authorized_keys
For ssh development, it allows users not to have to give the password
* `cp ~/authorized_keys dockerfiles/docker-build-assets/files-from-host-user/`


#### Create the key for signing JWT

  * `cp traquer-instance/volumes/julia-server/jwt_signing_keys.json.tpl traquer-instance/volumes/julia-server/jwt_signing_keys.json`
  * Generate a HS256 string (see traquer-instance/volumes/julia-server/README.md) and replace it in jwt_signing_keys.json

#### Create TRAQUER.jl and its configuration file
  * `cd traquer-instance/volumes/julia-server/CODE/`
  * `git clone git@github.com:TRAqueR-BHR/TRAQUER.jl.git`
  * `vi TRAQUER.jl/conf/whatever_name_you_want.conf`

#### Create startup.jl

  * `cp traquer-instance/volumes/julia-server/.julia/config/startup.jl.tpl traquer-instance/volumes/julia-server/.julia/config/startup.jl`
  * `vi traquer-instance/volumes/julia-server/.julia/config/startup.jl`

#### Create nginx config file

  * `cp traquer-instance/volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf.tpl traquer-instance/volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf`
  * `vi traquer-instance/volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf`

NOTE: Don't forget to modify the server_name

## HOWTO set up VM for Postgresql

### Install/Enable ufw, open port 5432
```
sudo apt-get install ufw
sudo ufw enable
sudo ufw allow 5432
```

### Add User and DB with template0 so that we can restore a dump from a database with a different name
CREATE USER traquer_creteil WITH PASSWORD 'your_password'
CREATE DATABASE traquer_creteil TEMPLATE template0 OWNER traquer_creteil;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

### Initialize the database with an existing database

#### Dump and restore

`pg_dump -Fc traquer > traquer-2022-03-19.dump`
`pg_restore -d traquer_creteil --no-owner --role=traquer_creteil /tmp/traquer-2022-03-19.dump`

## HOWTO set up NFS
Use `setfacl`
(https://debian-facile.org/doc:systeme:acl)
