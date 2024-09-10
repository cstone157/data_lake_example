#!/bin/bash

## Variable Definitions
##     - #1 => Name of the k8 to deploy (Required)
##     - #2 => path of the deployment yaml (Required)
##     - #3 => username to add to the k8 pod, if you don't pass one, then it will use read to get one.
##          If you pass -1, then it won't use one.
##     - #4 => password to add to the k8 pod, if you don't pass one, then it will use read to get one.
##          If you pass -1, then it won't use one.
function add_k8_pod {
    name=$1
    path=$2
    username=$3
    password=$4

    if [ -z ${username+x} ];
    then
        read -p "Enter $name username:" username
    fi
    if [ -z ${password+x} ];
    then
        read -p "Enter $name password:" password
    fi

    # Exclude the username/password, if it is -1
    if [ $username != -1 ];
    then
        username=$(echo -ne "$username" | base64);
        eval 'export username="$username"'
    fi
    if [ $password != -1 ];
    then
        password=$(echo -ne "$password" | base64);
        eval 'export password="$password"'
    fi


    #echo "name: $name, path: $path, username: $username, password: $password, " # For Debugging
    # Generate our k8s pod (use envsubst, for substitutions)
    printf "\n=============================================================================\nExecuting the $path, to create the service $name\n"
    envsubst < $path | kubectl apply -f -
}




clear
echo "Start Setting up our Kubernetes enviroment"

# Check if the commands we need to run are installed
if ! command -v envsubst &> /dev/null
then
    echo "envsubst could not be found, used for substitutions.  Please install with something like:\n     $ apt-getg y install getext-base\nInstallation, with vary based on distro."
    exit 1
fi



## ================ POSTGRES BLOCK ================
# Get the postgres username and password.
#printf "\n=============================================================================\nCreating the postgresql Pod / Service\n"
#read -p "Enter postgresql username:" POSTGRES_USERNAME
#read -p "Enter postgresql password:" POSTGRES_PASSWORD
#POSTGRES_USERNAME="root"        # DELETE ME
#POSTGRES_PASSWORD="password"    # DELETE ME
#POSTGRES_USERNAME=$(echo -ne "$POSTGRES_USERNAME" | base64);
#POSTGRES_PASSWORD=$(echo -ne "$POSTGRES_PASSWORD" | base64);
#eval 'export POSTGRES_USERNAME="$POSTGRES_USERNAME"'
#eval 'export POSTGRES_PASSWORD="$POSTGRES_PASSWORD"'

# Generate our secretes in kubernetes (use envsubst, for substitutions)
#envsubst < postgres/postgres-secret.yaml | kubectl apply -f -

# Run the postgres config-map
#kubectl apply -f postgres/postgres-configmap.yaml

# Build/Deploy the Postgres db
#kubectl apply -f postgres/postgres-deploy.yaml
add_k8_pod "postgres" "postgres/postgres.yaml" "root" "password"


## ================= PGADMIN BLOCK ================
#printf "\n=============================================================================\nCreating the pgadmin Pod / Service\n"
# Get the pgadmin password.
#read -p "Enter pgadmin password:" PGADMIN_PASSWORD
#PGADMIN_PASSWORD="password"    # DELETE ME
#PGADMIN_PASSWORD=$(echo -ne "$PGADMIN_PASSWORD" | base64);
#eval 'export PGADMIN_PASSWORD="$PGADMIN_PASSWORD"'

# Generate our secretes in kubernetes (use envsubst, for substitutions)
#envsubst < pgadmin/pgadmin-secret.yaml | kubectl apply -f -

# Build/Deploy our pgadmin instance
#kubectl apply -f pgadmin/pgadmin-deploy.yaml
add_k8_pod "pgadmin" "pgadmin/pgadmin.yaml" -1 "password"


## ================== MONGO BLOCK =================
#printf "\n=============================================================================\nCreating the mongo Pod / Service\n"
#add_k8_pod "mongo", "mongo/mongo-deploy.yaml" # Require the user to input the username/password
add_k8_pod "mongo" "mongo/mongo.yaml" "root" "password"


# Show all of our relavent pods / services
printf "\n=============================================================================\nResults\n"
kubectl get all -o wide

