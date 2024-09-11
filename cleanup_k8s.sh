#!/bin/bash

clear
kubectl delete --all pod
sleep .5
kubectl delete --all service
sleep .5
kubectl delete --all deployment
sleep .5
kubectl delete --all replicaset
sleep 3
kubectl delete --all secret
sleep 3
kubectl get all -o wide