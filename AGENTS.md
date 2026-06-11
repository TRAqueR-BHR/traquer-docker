# AGENTS.md — traquer-docker

Docker Compose infrastructure for the TRAQUER stack. This repository is separate from the Julia backend and Angular frontend repositories.

```
traquer-docker/
├── README.md
├── traquer-instance/        # main TRAQUER compose stack
│   ├── docker-compose.yaml
│   ├── dot-env.tpl          # template for .env
│   ├── build-docker-image.sh
│   ├── run-docker-container.sh
│   ├── restart-docker-container.sh
│   ├── dockerfiles/
│   │   ├── Dockerfile-julia
│   │   ├── Dockerfile-nginx
│   │   └── docker-build-assets/
│   └── volumes/             # local bind-mounted data/config, mostly gitignored
└── pgadmin/                 # separate pgAdmin compose setup, currently unrelated
```

## Main working directory

Most commands should be run from:

```bash
traquer-instance/
```

## Environment setup

Create the compose environment file from the template:

```bash
cp dot-env.tpl .env
```

Then fill/edit paths and ports in `.env`.

Important variables:

- `TRAQUER_BACKEND_SRC_CODE_DIR` — absolute path to the `TRAQUER.jl/` checkout.
- `TRAQUER_FRONTEND_SRC_CODE_DIR` — absolute path to the `traquer-frontend-angular/` checkout.
- `TRAQUER_DATA_DIR` — host data directory mounted into the Julia container.
- `POSTGRES_DATA_DIR` — host PostgreSQL data directory.
- `TRAQUER_PENDING_INPUT_FILES_DIR`, `TRAQUER_PROCESSING_INPUT_FILES_DIR`, `TRAQUER_DONE_INPUT_FILES_DIR`, `TRAQUER_INPUT_FILES_PROBLEMS_DIR` — ETL exchange directories.
- `PI_HOME_DIR` — host Pi agent state, usually `/home/vlaugier/.pi`.
- `PI_NODE_DIR` — host Node install containing the Pi executable, usually `/home/vlaugier/.nvm/versions/node/v24.10.0`.
- `TMUX_CONFIG_DIR` — host tmux config directory if mounted/used.

`.env` is gitignored. If a new required variable is added to `.env`, also add it to `dot-env.tpl`.

## Build/run commands

From `traquer-instance/`:

```bash
./build-docker-image.sh
./run-docker-container.sh
./restart-docker-container.sh
```

Or directly with compose:

```bash
docker compose build traquer-julia-server
docker compose up -d --force-recreate traquer-julia-server
```

Validate compose after edits:

```bash
docker compose config --quiet
```

## Services

### `traquer-julia-server`

- Built from `dockerfiles/Dockerfile-julia`.
- Container name: `traquer-julia-server-${SYST_USER_TAG}`.
- Exposes the Julia API port `8095` through `${JULIA_API_PORT}`.
- Exposes SSH port `22` through `${SSH_PORT}`.
- The command is intentionally:

```yaml
command: tail -F /dev/null
```

The Julia web server is **not** started automatically. After the container starts, exec/SSH into it and run the backend manually from the mounted `TRAQUER.jl` checkout:

```bash
julia scripts/web/start-web-server.jl
```

### `traquer-postgresql-16-server`

- PostgreSQL 16.1.
- Container name: `traquer-postgresql-16`.
- Data mounted from `${POSTGRES_DATA_DIR}/postgresql-data-16`.
- Exposes container port `5432` through `${POSTGRES_DEV_DB_PORT}`.

### `traquer-nginx-server`

- Built from `dockerfiles/Dockerfile-nginx`.
- Serves built Angular static files from mounted `volumes/nginx-server/html/...` directories.
- Nginx config is mounted from `volumes/nginx-server/conf/traquer-frontend-angular.nginx.conf`.

## Pi and Linuxbrew in the Julia container

The Julia container can use the host Pi coding agent by bind-mounting:

```yaml
- ${PI_HOME_DIR}:/home/traquer/.pi
- ${PI_NODE_DIR}:/home/traquer/.nvm/versions/node/v24.10.0:ro
```

The compose `PATH` includes the mounted Node/Pi binary directory, so `pi` should be available as user `traquer`.

Linuxbrew is installed/bootstraped into a persistent local volume:

```yaml
- ./volumes/julia-server/linuxbrew:/home/linuxbrew
```

The installed Homebrew tree is ignored by git; only `.gitkeep` should be tracked. Do not commit the contents of `volumes/julia-server/linuxbrew/.linuxbrew/`.

`dockerfiles/docker-build-assets/install-linuxbrew-if-needed.sh` is run by the entrypoint and installs Homebrew into `/home/linuxbrew/.linuxbrew` if missing.

## Git hygiene

Do not commit:

- `traquer-instance/.env`
- `traquer-instance/volumes/julia-server/jwt_signing_keys.json`
- `traquer-instance/volumes/julia-server/.pgpass`
- generated Julia depot content under `volumes/julia-server/.julia/`
- generated frontend builds under `volumes/nginx-server/html/`
- Linuxbrew installed packages under `volumes/julia-server/linuxbrew/.linuxbrew/`
- host SSH/private files under `dockerfiles/docker-build-assets/files-from-host-user/`

Before committing, check:

```bash
git status --short
docker compose config --quiet
```

There may be unrelated untracked files under `pgadmin/`; do not include them unless the task explicitly concerns pgAdmin.
