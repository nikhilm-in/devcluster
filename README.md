# DevCluster

Vagrant based local kubernetes cluster for development. 

It provisions 3 nodes running Ubuntu 20.04 Focal and sets up:
* 1 controlplane node (node0)
* 2 dataplane nodes (node1,node2)
* Calico overlay network

To make it very easy to bring up the cluster without much work, some assumptions are made. Such as:
* You already have Virtualbox running as this vagrant file uses the Virtualbox provider.
* your network can resolve the 192.168.0.0/16 ip range and there are no devices with the ip 192-168.0.200-192-168.0.202.
* You are running this on MacOS Big Sur and above. It may work on other OS but I have not tested it.
* The resources allocated to the VMs are also what can be run on my machine. You may want to revisit that.

### Steps:
* Clone this repository
* Make sure vagrant is setup
* Run the command vagrant up.
* Open the [Kubeconfig web page](http://192.168.0.200) and click on download to get the Kubeconfig file.


### Things to do:
* Automated way to export kubeconfig file from cluster without manual steps
* [MetalLB](https://metallb.universe.tf/)
* Provision secondary disk and install [Longhorn](https://longhorn.io/)