#!/bin/bash



## Helper function for creating a k8s pod
function add_jupyter_k8s_pod {
    _local_volume_path=$(pwd)
    _local_volume_path="$_local_volume_path/jupyter/work"
    read -p "If you want to use a local volume (storage) for the JupyterHub's work directory. \nDefault will be $_local_volume_path, NA to not use a local volume: " _user_specified_path

    name="Jupyter"
    path="jupyter/jupyter.yaml"

    if [ $_user_specified_path != "NA" ]:
    then
        if [ $_user_specified_path != "" ]:
        then
            _local_volume_path=$_user_specified_path
        fi

        path="jupyter/jupyter-w-local.yaml"
        eval 'export _local_volume_path="$_local_volume_path"'
    fi

    printf "\n=============================================================================\nExecuting the $path, to create the service $name\n"
    envsubst < $path | kubectl apply -f -
}


## =================================================================================================================================================================================
##                                                                      Purge our K8S and/or Docker enviroment                                                                      
## =================================================================================================================================================================================
function cleanupCommand {
    docker=false
    kubernetes=false

    if [ -z ${1+x} ] || [ $1 == "--help" ]; then
        printf "When using the cleanup command, you need to specify:\n\t-a\tClean everything (kubernetes and docker)\n\t-k\tClean Kubernetes\n\t-d\tClean Docker"
        exit 0
    elif [ $1 == "-a" ]; then
        docker=true
        kubernetes=true
    elif [ $1 == "-k" ]; then
        kubernetes=true
    elif [ $1 == "-d" ]; then
        docker=true
    fi

    clear
    ## If any of our parameters are kubernetes, then go ahead and cleanup our kubernetes enviroment
    if [ $kubernetes == true ]; then
#        kubectl delete namespace stone-data-lake
#        kubectl delete pvc --all
#        kubectl delete pv keycloak-pv postgres-pv
#        kubectl delete pv --all
#        kubectl delete secrets --all
#        kubectl delete pvc --all & kubectl delete pv --all & kubectl delete secrets --all
#        kubectl delete namespace stone-data-lake & kubectl delete pvc --all & kubectl delete pv --all & kubectl delete secrets --all & kubectl delete configmap --all

        printf "== Start Cleaning up our Kubernetes data-lake enviroment"
        kubectl delete namespace stone-data-lake & kubectl delete pvc --all & kubectl delete pv --all & kubectl delete secrets --all & kubectl delete configmap --all
    fi

    ## If any of our parameters are docker, then go ahead and cleanup our docker enviroment
    if [ $docker == true ]; then
        if [ $kubernetes == true ]; then
            printf "."
            sleep 3s
            printf "."
            sleep 3s
            printf "."
            sleep 3s
            printf "."
            sleep 3s
            printf "."
            sleep 3s
            printf ".\n"
        fi

        printf "\n== Start Cleaning up our Docker data-lake enviroment"
        docker image rm localhost:5000/data-lake-postgres localhost:5000/data-lake-pgadmin localhost:5000/data-lake-keycloak
        docker container stop registry
        docker container rm registry
    fi
}

## =================================================================================================================================================================================
##                                                                      Build our K8S and/or Docker enviroment                                                                      
## =================================================================================================================================================================================
function buildCommand {
    docker=false
    kubernetes=false

    if [ -z ${1+x} ] || [ $1 == "--help" ]; then
        printf "When using the build command, you need to specify:\n\t-a\tBuild everything (kubernetes and docker)\n\t-k\tBuild Kubernetes\n\t-d\tBuild Docker"
        exit 0
    elif [ $1 == "-a" ]; then
        docker=true
        kubernetes=true
    elif [ $1 == "-k" ]; then
        kubernetes=true
    elif [ $1 == "-d" ]; then
        docker=true
    fi

    # Check if the commands we need to run are installed
    if ! command -v envsubst &> /dev/null
    then
        echo "envsubst could not be found, used for substitutions.  Please install with something like:\n     $ apt-getg y install getext-base\nInstallation, with vary based on distro."
        exit 1
    fi


    clear

    ## Build our enviroment variables that we will need
    ### Create our keycloak database user & password
    keycloak_db="keycloak"
    keycloak_db_username="keycloak"
    keycloak_db_password="keycloak-password"
    export keycloak_db_username="$keycloak_db_username"
    export keycloak_db_password="$keycloak_db_password"

    export keycloak_db_username_b64=$(echo -ne $keycloak_db_username | base64)
    export keycloak_db_password_b64=$(echo -ne $keycloak_db_password | base64)
    export keycloak_db_b64=$(echo -ne $keycloak_db | base64)

    #### Create our password/username for our secrests
    default_username="admin"
    default_password="admin"
    default_email="admin@admin.com"

    export postgres_root_username_b64=$(echo -ne $default_username | base64)
    export postgres_root_password_b64=$(echo -ne $default_password | base64)
    export postgres_local_path="//run/desktop/mnt/host/c/Users/c.stone/Documents/GitHub/data_lake_example/postgres/data"
#    export postgres_local_path="data_lake_example\postgres\data"

    export pgadmin_root_username_b64=$(echo -ne $default_email | base64)
    export pgadmin_root_password_b64=$(echo -ne $default_password | base64)
    export keycloak_admin_username_b64=$(echo -ne $default_username | base64)
    export keycloak_admin_password_b64=$(echo -ne $default_password | base64)

    export _username=$(echo -ne $default_username | base64)
    export _password=$(echo -ne $default_password | base64)
#    echo $postgres_local_path



    if [ $docker == true ]; then
        ## Local Registry
        #### FIX-ME: REPLACE WITH A CHECK TO DETERMIN IF THE REGISTRY IS ALREADY RUNNING
        printf "Ensuring that the Docker registry is up and running:\n"
        docker run -d -p 5000:5000 --restart=always --name registry registry:2


        ### Build my dockerfiles
        #### Postgres has some build files that need to be setup first
        printf "\nBuilding our docker image and configuration files\n"
        touch postgres/preloaded_data/01-keycloak.sql
        envsubst < postgres/preloaded_data/01-keycloak > postgres/preloaded_data/01-keycloak.sql

        docker build ./postgres/ -t localhost:5000/data-lake-postgres
        docker build ./keycloak/ -t localhost:5000/data-lake-keycloak
        docker build ./pgadmin/ -t localhost:5000/data-lake-pgadmin
        
        rm postgres/preloaded_data/01-keycloak.sql


        ### Push the docker-image to the local registry
        printf "\nPush the docker-image to the registry\n"
        docker push localhost:5000/data-lake-postgres
        docker push localhost:5000/data-lake-keycloak
        docker push localhost:5000/data-lake-pgadmin
    fi

    if [ $kubernetes == true ]; then
        if [ $docker == true ]; then
            echo ""
        fi
        echo "Start Setting up our Kubernetes data-lake enviroment"



        ## =============== JUPYTERHUB BLOCK ===============
#        printf "=============================================================================\nSetup JupyterHub Pod\n"
#        add_jupyter_k8s_pod

#        add_k8s_pod "jupyter" "jupyter/jupyter.yaml" -1 -1
        ## Get all the nodes
#        kubectl get node
        ## label the node with local-storage
#        kubectl label nodes <node-name> local-storage-available=true
        ## Create the persistent volumes for the local hard-drive
#        kubectl apply -f jupyter/jupyter-volume.yaml


        ## TLS Certificate and key
        ## The openssl doesn't work in "git bash", need to run it in regular bash or powershell
#        openssl req -subj '/CN=test.keycloak.org/O=Test Keycloak./C=US' -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
#        kubectl create secret tls example-tls-secret --cert certificate.pem --key key.pem

        ## Create data-lake
        ### Setup the namespace, configmap, and secrets
        envsubst < data-lake.yaml | kubectl apply -f -

        ### Setup the postgresql pods
        printf "\n=============================================================================\nSetup Postgres Pod\n"
        #kubectl apply -f postgres/postgres.yaml
        envsubst < postgres/postgres.yaml | kubectl apply -f -

        ### Setup the pgadmin pod / service
        printf "\n=============================================================================\nSetup PgAdmin Pod\n"
        #kubectl apply -f pgadmin/pgadmin.yaml
        envsubst < pgadmin/pgadmin.yaml | kubectl apply -f -

        ### Setup the Keycloak pod / service
        printf "\n=============================================================================\nSetup Keycloak Pod\n"
        envsubst < keycloak/keycloak.yaml | kubectl apply -f -

        ### ============== Show all of our relavent pods / services ==============
        printf "\n=============================================================================\nResults\n"
        kubectl get all -o wide -n stone-data-lake
    fi
}


_command="$1"
## ========== EXECUTE THE CLEANUP COMMAND BLOCK ===========
if [ "$_command" == "cleanup" ]; then
    cleanupCommand $2
fi

## ============== EXECUTE BUILD COMMAND BLOCK =============
if [ "$_command" == "build" ]; then
    buildCommand $2
fi
