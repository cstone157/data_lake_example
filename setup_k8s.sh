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
    _username=$3
    _password=$4

    if [ -z ${_username+x} ];
    then
        read -p "Enter $name username:" _username
    fi
    if [ -z ${_password+x} ];
    then
        read -p "Enter $name password:" _password
    fi

    # Exclude the username/password, if it is -1
    if [ $_username != -1 ];
    then
        _username=$(echo -ne "$_username" | base64);
        eval 'export _username="$_username"'
    fi
    if [ $_password != -1 ];
    then
        _password=$(echo -ne "$_password" | base64);
        eval 'export _password="$_password"'
    fi


    #echo "name: $name, path: $path, username: $_username, password: $_password, " # For Debugging
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
add_k8_pod "postgres" "postgres/postgres.yaml" "root" "password"

## ================= PGADMIN BLOCK ================
add_k8_pod "pgadmin" "pgadmin/pgadmin.yaml" -1 "password"

## ================== MONGO BLOCK =================
#add_k8_pod "mongo", "mongo/mongo-deploy.yaml" # Require the user to input the username/password
add_k8_pod "mongo" "mongo/mongo.yaml" "root" "password"

## ============== MONGO-EXPRESS BLOCK =============
add_k8_pod "mongo-express" "mongo-express/mongo-express.yaml" "root" "password"

## =============== JUPYTERHUB BLOCK ===============
add_k8_pod "jupyter" "jupyter/jupyter.yaml" -1 -1

# Show all of our relavent pods / services
printf "\n=============================================================================\nResults\n"
kubectl get all -o wide
