# data_lake_example
A simplified example of the data-lake using Kubernetes

# Cloning project:

# Setup of Kubernetes


# NOTES:
###    - To encode something using base64:
###        - $ echo -n 'root' | base64

# KUBERNETES:
###    - Get all resources
###        - $ kubectl get all
###    - Delete all resources
###        - $ kubectl delete --all namespaces
###    - Connect to a pod and access it's commandline.
###        - $ kubectl exec -it postgres-5c7d8b656d-xj5b2 -- /bin/bash
###    - Get the logs of our pod
###        - $ kubectl logs postgres-5c7d8b656d-xj5b2

# RESOURCES
###    - https://dev.to/dm8ry/how-to-deploy-postgresql-db-server-and-pgadmin-in-kubernetes-a-how-to-guide-5fm0
