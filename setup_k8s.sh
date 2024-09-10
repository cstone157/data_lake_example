#!/bin/bash

echo "Start Setting up our Kubernetes enviroment"

# Check if the commands we need to run are installed
if ! command -v envsubst &> /dev/null
then
    echo "envsubst could not be found, used for substitutions.  Please install with something like:\n     $ apt-getg y install getext-base\nInstallation, with vary based on distro."
    exit 1
fi

# Get the postgres username and password.
printf "Creating the postgresql Pod / Service\n"
#read -p "Enter postgresql username:" POSTGRES_USERNAME
#read -p "Enter postgresql password:" POSTGRES_PASSWORD
POSTGRES_USERNAME="root"        # DELETE ME
POSTGRES_PASSWORD="password"    # DELETE ME
POSTGRES_USERNAME=$(echo -ne "$POSTGRES_USERNAME" | base64);
POSTGRES_PASSWORD=$(echo -ne "$POSTGRES_PASSWORD" | base64);
eval 'export POSTGRES_USERNAME="$POSTGRES_USERNAME"'
eval 'export POSTGRES_PASSWORD="$POSTGRES_PASSWORD"'

# Generate our secretes in kubernetes (use envsubst, for substitutions)
envsubst < postgres/postgres-secret.yaml | kubectl apply -f -

# Run the postgres config-map
kubectl apply -f postgres/postgres-configmap.yaml

# Build/Deploy the Postgres db
kubectl apply -f postgres/postgres-deploy.yaml

# Get the pgadmin password.
printf "\n=============================================================================\nCreating the pgadmin Pod / Service\n"
#read -p "Enter pgadmin password:" PGADMIN_PASSWORD
PGADMIN_PASSWORD="password"    # DELETE ME
PGADMIN_PASSWORD=$(echo -ne "$PGADMIN_PASSWORD" | base64);
eval 'export PGADMIN_PASSWORD="$PGADMIN_PASSWORD"'

# Generate our secretes in kubernetes (use envsubst, for substitutions)
envsubst < pgadmin/pgadmin-secret.yaml | kubectl apply -f -

# Build/Deploy our pgadmin instance
kubectl apply -f pgadmin/pgadmin-deploy.yaml

# Show all of our relavent pods / services
printf "\n=============================================================================\nResults\n"
kubectl get all

