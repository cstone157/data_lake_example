#!/bin/bash

## Add a k8 pod, needs a name for the pod (mostly for readability purposes) and the path of the yaml
##     for creating our pod / pods
##
## Variable Definitions
##     - #1 => Name of the k8 to deploy (Required)
##     - #2 => path of the deployment yaml (Required)
##     - #3 => username to add to the k8 pod, if you don't pass one, then it will use read to get one.
##          If you pass -1, then it won't use one.
##     - #4 => password to add to the k8 pod, if you don't pass one, then it will use read to get one.
##          If you pass -1, then it won't use one.
function add_k8s_pod {
    name=$1
    path=$2
    _username=$3
    _password=$4

    if [ -z ${_username+x} ];
    then
        read -p "Enter $name app's username:" _username
    fi
    if [ -z ${_password+x} ];
    then
        read -p "Enter $name app's password (for username, if one selected):" _password
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


## Helper function for creating a k8s pod
function add_jupyter_k8s_pod {
    _local_volume_path=$(pwd)
    _local_volume_path="$_local_volume_path/jupyter/work"
    read -p "If you want to use a local volume (storage) for the JupyterHub's work directory. \nDefault will be $_local_volume_path, NA to not use a local volume: " _user_specified_path

    name="Jupyter"
    path="jupyter/jupyter.yaml"

    if [$_user_specified_path != "NA"]:
    then
        if [$_user_specified_path != ""]:
        then
            _local_volume_path=$_user_specified_path
        fi

        path="jupyter/jupyter-w-local.yaml"
        eval 'export _local_volume_path="$_local_volume_path"'
    fi

    printf "\n=============================================================================\nExecuting the $path, to create the service $name\n"
    envsubst < $path | kubectl apply -f -
}



## ================= SETUP BLOCK ==================
clear
echo "Start Setting up our Kubernetes enviroment"

# Check if the commands we need to run are installed
if ! command -v envsubst &> /dev/null
then
    echo "envsubst could not be found, used for substitutions.  Please install with something like:\n     $ apt-getg y install getext-base\nInstallation, with vary based on distro."
    exit 1
fi

## ================ POSTGRES BLOCK ================
printf "=============================================================================\nSetup Postgres Pod\n"
add_k8s_pod "postgres" "postgres/postgres.yaml" "root" "password"

## ================= PGADMIN BLOCK ================
printf "\n=============================================================================\nSetup PgAdmin Pod\n"
add_k8s_pod "pgadmin" "pgadmin/pgadmin.yaml" -1 "password"

## ================== MONGO BLOCK =================
printf "=============================================================================\nSetup Mongo Pod\n"
#add_k8_pod "mongo", "mongo/mongo-deploy.yaml" # Require the user to input the username/password
add_k8s_pod "mongo" "mongo/mongo.yaml" "root" "password"

## ============== MONGO-EXPRESS BLOCK =============
printf "=============================================================================\nSetup Mongo-Express Pod\n"
add_k8s_pod "mongo-express" "mongo-express/mongo-express.yaml" "root" "password"


## =============== JUPYTERHUB BLOCK ===============
printf "=============================================================================\nSetup JupyterHub Pod\n"
add_jupyter_k8s_pod

#add_k8s_pod "jupyter" "jupyter/jupyter.yaml" -1 -1
## Get all the nodes
#kubectl get node
## label the node with local-storage
#kubectl label nodes <node-name> local-storage-available=true
## Create the persistent volumes for the local hard-drive
#kubectl apply -f jupyter/jupyter-volume.yaml


## =============== REPORT/END BLOCK ===============
# Show all of our relavent pods / services
printf "\n=============================================================================\nResults\n"
kubectl get all -o wide
