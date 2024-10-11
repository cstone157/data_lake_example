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
##                                                                      Deploy a registry to Docker
## =================================================================================================================================================================================
function buildRegistry {
    registry_status="$(docker ps -f 'name=registry')"
    if [[ "$registry_status" =~ "registry" ]]; then
        printf "Registry container already exists:\n"
    else
        printf "Creating Docker registry container:\n"
        docker run -d -p $registry_port:$registry_image_port --restart=always --name registry registry:2
    fi
}

## =================================================================================================================================================================================
##                                                                      Build our Docker Images and deploy to the registry
## =================================================================================================================================================================================
function buildDockerImages {
    ## Local Registry
    buildRegistry

    ### Build my dockerfiles
    #### Postgres has some build files that need to be setup first
    printf "\nBuilding our docker image and configuration files\n"
    touch postgres/preloaded_data/01-keycloak.sql
    envsubst < postgres/preloaded_data/01-keycloak > postgres/preloaded_data/01-keycloak.sql

    docker build ./postgres/ -t localhost:$registry_port/data-lake-postgres
    docker build ./keycloak/ -t localhost:$registry_port/data-lake-keycloak
    docker build ./pgadmin/ -t localhost:$registry_port/data-lake-pgadmin
    
    rm postgres/preloaded_data/01-keycloak.sql


    ### Push the docker-image to the local registry
    printf "\nPush the docker-image to the registry\n"
    docker push localhost:$registry_port/data-lake-postgres
    docker push localhost:$registry_port/data-lake-keycloak
    docker push localhost:$registry_port/data-lake-pgadmin
}

## =================================================================================================================================================================================
##                                                                      Build our Kubernetes Enviroment                                                                      
## =================================================================================================================================================================================
function buildKubernetes {
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

    sleep 5s

    ### Setup the Keycloak pod / service
    printf "\n=============================================================================\nSetup Keycloak Pod\n"
    envsubst < keycloak/keycloak.yaml | kubectl apply -f -

    ### ============== Show all of our relavent pods / services ==============
    printf "\n=============================================================================\nResults\n"
    kubectl get all -o wide -n stone-data-lake


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

    ## Clear the screen & Build all of our variables
    clear
    build_variables

    if [ $docker == true ]; then
        buildDockerImages
    fi

    if [ $kubernetes == true ]; then
        if [ $docker == true ]; then
            printf "\n"
        fi
        printf "Start Setting up our Kubernetes data-lake enviroment\n"
        buildKubernetes
    fi
}