#!/bin/bash
set -m

kc_cmd="/opt/keycloak/bin/kc.sh";

## Start the keycloak server in the background
#eval "${kc_cmd} start-dev &"
#eval "${kc_cmd} start &"
eval "${kc_cmd} start --optimized &"

# Wait 
sleep 15s

exit_loop=0
declare -i loop_count=0
while [ $exit_loop == 0 ]
do
    ## Authenticate our connection to the api of keycloak
    echo "========== Attempting to configure connection to enable creating realms and services"
    realm_result="$(/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin 2>&1 /dev/null)"

    ERR_MSG_1="WARN"
    ERR_MSG_2="ERROR"
    ERR_MSG_3="Failed"

    if [[ "$realm_result" == *"$ERR_MSG_1"* ]] || [[ "$realm_result" == *"$ERR_MSG_2"* ]] || [[ "$realm_result" == *"$ERR_MSG_3"* ]]; then
        loop_count=$loop_count+1
        echo "== FAILED to connect $loop_count times"
        if [ $loop_count -gt 15 ]; then
            exit_loop=true
        fi

        sleep 15s
    else
        exit_loop=1

        ## Create data_lake ream and the nifi client
        echo "========== - Creating data_lake realm"
        /opt/keycloak/bin/kcadm.sh create realms -s realm=data_lake -s enabled=true -o
        #/opt/keycloak/bin/kcadm.sh create clients -r data_lake -s clientId=nifi -s 'redirectUris=["http://localhost:8980/myapp/*"]' -i
    fi
done

## Restore the keycloak server to the foreground
fg 1