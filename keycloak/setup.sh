#!/bin/bash
  
## Authenticate our connection to the api of keycloak
#/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin --password admin
/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password admin

## Create data_lake ream and the nifi client
/opt/keycloak/bin/kcadm.sh create realms -s realm=cts_data_lake -s enabled=true -o
#/opt/keycloak/bin/kcadm.sh create clients -r cts_data_lake -s clientId=nifi -s 'redirectUris=["http://localhost:8980/myapp/*"]' -i
