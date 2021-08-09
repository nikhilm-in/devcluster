#!/bin/bash

sudo apt install nginx -y

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --upload-certs --apiserver-advertise-address=192.168.0.200 --pod-network-cidr=10.254.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy overlay network
echo "[TASK 3] Deploy overlay network"
su - vagrant -c "kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml"


# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
sudo kubeadm token create --print-join-command --ttl 0
echo "sudo kubeadm join $(sudo cat /etc/kubernetes/kubelet.conf | grep server | cut -d '/' -f 3) --token $(sudo kubeadm token list | grep forever | cut -c 1-23) --discovery-token-ca-cert-hash sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')" > /var/www/html/index.nginx-debian.html
