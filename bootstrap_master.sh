#!/bin/bash
echo "########## Starting controlplane setup on $HOSTNAME ##########"
# Initialize Kubernetes
echo "[CONTROLPLANE TASK 1] Initialize Kubernetes Cluster"
kubeadm init --upload-certs --apiserver-advertise-address=192.168.0.200 --pod-network-cidr=10.254.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "########## Starting controlplane setup on $HOSTNAME ##########"
echo "[CONTROLPLANE TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy overlay network
echo "[CONTROLPLANE TASK 3] Deploy overlay network"
su - vagrant -c "kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml"


# Generate Cluster join command
echo "[CONTROLPLANE TASK 4] Generate and save cluster join command to /joincluster.sh"
sudo kubeadm token create --print-join-command --ttl 0

echo "[CONTROLPLANE TASK 5] Exporting Kubeconfig file through nginx on master node ip"


sudo apt install nginx -y
cat <<EOF | sudo tee /var/www/html/index.nginx-debian.html
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Add icon library -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
.btn {
  background-color: DodgerBlue;
  border: none;
  color: white;
  padding: 12px 30px;
  cursor: pointer;
  font-size: 20px;
}
/* Darker background on mouse-over */
.btn:hover {
  background-color: RoyalBlue;
}
</style>
</head>
<body>
<h2>Download devcluster Kubeconfig file</h2>
<a href="admin.conf" download="devcluster-k8s.yaml" download><button class="btn"><i class="fa fa-download"></i> Download</button></a>
</body>
</html>
EOF

echo "Copying the admin.conf to be available at the path /admin.conf"
sudo cp /etc/kubernetes/admin.conf /var/www/html/admin.conf

echo "Adding the join command at /join path"
echo "sudo kubeadm join $(sudo cat /etc/kubernetes/kubelet.conf | grep server | cut -d '/' -f 3) --token $(sudo kubeadm token list | grep forever | cut -c 1-23) --discovery-token-ca-cert-hash sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')" | sudo tee /var/www/html/join

echo "Setting 644 file permissions for all files in /var/www/html dir"
sudo chmod 644 /var/www/html/*

echo "########## Completed controlplane setup on $HOSTNAME ##########"