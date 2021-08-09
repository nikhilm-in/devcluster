# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "node0" do |node0|
    node0.vm.box = "bento/ubuntu-18.04"
    node0.vm.hostname = "node0"
    node0.vm.network "public_network", ip: "192.168.0.200", bridge: "en0: Wi-Fi (Wireless)"
    node0.vm.provider "virtualbox" do |v|
      v.name = "node0"
      v.memory = 4096
      v.cpus = 2
    end
    node0.vm.provision "shell", path: "bootstrap_master.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = "bento/ubuntu-18.04"
      node.vm.hostname = "node#{i}"
      node.vm.network "public_network", ip: "192.168.0.20#{i}", bridge: "en0: Wi-Fi (Wireless)"
      node.vm.provider "virtualbox" do |v|
        v.name = "node#{i}"
        v.memory = 4096
        v.cpus = 2
      end
      node.vm.provision "shell", path: "bootstrap_worker.sh"
    end
  end

end
