TRAQUER_DATA_DIR=/home/traquer_dev/DATA/TRAQUER
TRAQUER_PENDING_INPUT_FILES_DIR=/home/filepusher/PENDING
TRAQUER_PROCESSING_INPUT_FILES_DIR=/home/filepusher/PROCESSING
TRAQUER_DONE_INPUT_FILES_DIR=/home/filepusher/DONE
TRAQUER_INPUT_FILES_PROBLEMS_DIR=/home/filepusher/PROBLEM
COMPOSE_PROJECT_NAME=traquer-dev-vincent # This allows the same service to have multiple instances
SSH_PORT=7922
SSH_PASSWORD=change_me_2023
JULIA_API_PORT=7980
NGINX_PORT=7981
SYST_USER_TAG=dev-vincent
TRAQUER_FRONTEND_SRC_CODE_DIR=/home/vlaugier/CODE/BHRE/traquer-frontend-angular

# The variables below are needed for the initialization of the configuration of the pgbouncer
DB_USER=traquer
DB_NAME=traquer
DB_PASSWORD=xxxxxxxx
DB_HOST=172.19.0.1 # This is the IP of the postgresql server, not the pgbouncer server
DB_PORT=5432 # This is the port of the postgresql server, not the pgbouncer server
