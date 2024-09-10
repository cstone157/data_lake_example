# data_lake_example
A simplified example of the data-lake using Kubernetes

# Cloning project:

# Setup of Kubernetes

# PgAdmin
### Connecting pgAdmin to postgres using the IP ($ kubectl get all -o wide) for the postgres pod

# NOTES:
###    - To encode something using base64:
###        - $ echo -n 'root' | base64

# KUBERNETES:
###    - Get all resources
###        - $ kubectl get all
###    - Delete all resources
###        - $ kubectl delete --all namespaces
###    - Connect to a pod and access it's commandline.
###        - $ kubectl exec -it <pod-name> -- /bin/bash
###    - Get the logs of our pod
###        - $ kubectl logs <pod-name>
###    - Get the description of a pod
###        - $ kubectl describe pod <pod-name>
###    - Delete all Persistent volumes
###        - $ kubectl delete pvc --all 

# RESOURCES
###    - https://dev.to/dm8ry/how-to-deploy-postgresql-db-server-and-pgadmin-in-kubernetes-a-how-to-guide-5fm0
###    - https://medium.com/@lukhee/aws-deploying-mongo-database-image-to-aws-eks-4916d7883c9f

