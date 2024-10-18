#!/bin/bash

## Add our util and variables functions
source ./scripts/utils.sh
source ./scripts/variables.sh



# Check if the commands we need to run are installed
if ! command -v envsubst &> /dev/null
then
    printf "envsubst could not be found, used for substitutions.  Please install with something like:\n     $ apt-getg y install getext-base\nInstallation, with vary based on distro.\n"
    exit 1
fi

if ! command -v kubectl &> /dev/null
then
    if ! command -v minikube &> /dev/null
    then
        printf "kubectl and minikube not found, please fix"
        exit 1
    else
        #kubectl="minikube kubectl --"
        kubectl="minikube kubectl --"
    fi
else
    kubectl="kubectl"
fi

_command="$1"
## ========== EXECUTE THE CLEANUP COMMAND BLOCK ===========
if [ "$_command" == "cleanup" ]; then
    source ./scripts/cleanup.sh
    cleanupCommand $2
## ============== EXECUTE BUILD COMMAND BLOCK =============
elif [ "$_command" == "build" ]; then
    source ./scripts/build.sh
    buildCommand $2
## ============= EXECUTE STATUS COMMAND BLOCK =============
elif [ "$_command" == "status" ]; then
    kubectl get all -n stone-data-lake
    kubectl get persistentvolume -n stone-data-lake
    kubectl get persistentvolumeclaim -n stone-data-lake

## ================ OPEN PODS COMMAND LINE ================
elif [ "$_command" == "exec" ]; then
    kubectl exec -it -n stone-data-lake pod/keycloak-d67848c6-xkvm9 -- sh

## ============= TEMP REGISTRY COMMAND BLOCK =============
elif [ "$_command" == "registry" ]; then
    source ./scripts/build.sh
    buildRegistry

## ===================== ELSE BLOCK ======================
else
    printf "Error unrecorgnized command, the commands supported are ???? (fill me in later)\n"
fi
