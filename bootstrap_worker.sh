#!/bin/bash
echo "########## Joining $HOSTNAME to the cluster ##########"
# Join worker nodes to the Kubernetes cluster
echo "[DATAPLANE TASK 1] Join node to Kubernetes Cluster"
curl -s GET "node0" | bash 
echo "########## Joined $HOSTNAME to the cluster ##########"