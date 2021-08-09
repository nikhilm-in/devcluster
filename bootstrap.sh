#!/bin/bash
echo "########## Starting bootstrapping $HOSTNAME ##########"

echo "[BOOTSTRAP TASK 1] Setup basic node configs"

# Update hosts file
cat >>/etc/hosts<<EOF
192.168.0.200 node0
192.168.0.201 node1
192.168.0.202 node2
EOF

# Set Root password
echo -e "kubeadmin\nkubeadmin" | passwd root
#echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

# Enable ssh password authentication
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd

# Disable swap
sed -i '/swap/d' /etc/fstab
swapoff -a


echo "[BOOTSTRAP TASK 2] Configure docker and kubernetes files"
sudo modprobe br_netfilter
sudo mkdir /etc/docker
sudo /bin/bash -c 'cat > /etc/docker/daemon.json <<EOF
{
 "exec-opts": ["native.cgroupdriver=systemd"],
 "log-driver": "json-file",
 "log-opts": {
   "max-size": "100m",
   "max-file": "3"
 },
 "storage-driver": "overlay2"
}
EOF'

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sudo apt-get update
sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


echo "[BOOTSTRAP TASK 3] Enable and start docker service"
# Install docker, kubelet, kubectl and kubeadmin
sudo apt-get update
sudo apt-get install -y docker.io kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl docker.io
sudo systemctl enable docker.service
sudo systemctl enable kubelet.service

# add ccount to the docker group
usermod -aG docker vagrant
echo "########## Completed bootstrapping $HOSTNAME ##########"
