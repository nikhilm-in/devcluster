# DevCluster

Vagrant based local kubernetes cluster for development. 

It provisions 3 nodes running Ubuntu 20.04 Focal and sets up:
* 1 controlplane node (node0)
* 2 dataplane nodes (node1,node2)
* Calico overlay network

Things to do:
* Automated way to export kubeconfig file from cluster without further commands
* [MetalLB] (https://metallb.universe.tf/)
* Provision secondary disk and install [Longhorn] (https://longhorn.io/)