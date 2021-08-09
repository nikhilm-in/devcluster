# DevCluster

Vagrant based local kubernetes cluster for development. 

It provisions 3 nodes running Ubuntu 20.04 Focal and sets up:
* 1 controlplane node (node0)
* 2 dataplane nodes (node1,node2)
* Calico overlay network


Steps:
* Clone this repository
* Make sure vagrant is setup
* Run the command vagrant up.
* Open the [Kubeconfig web page](http://192.168.0.200/config.html) and click on download to get the Kubeconfig file.


Things to do:
* Automated way to export kubeconfig file from cluster without manual steps
* [MetalLB](https://metallb.universe.tf/)
* Provision secondary disk and install [Longhorn](https://longhorn.io/)