# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

VAGRANT_BOX         = "generic/ubuntu2204"
VAGRANT_BOX_VERSION = "4.0.2"
CPUS_MASTER_NODE    = 2
CPUS_WORKER_NODE    = 2
MEMORY_MASTER_NODE  = 2048
MEMORY_WORKER_NODE  = 2024
WORKER_NODES_COUNT  = 1 
ADD_NODES_COUNT  = 2 #allways have 1 master
LoadBalancerCount = 2

Vagrant.configure(2) do |config|
  

  config.vm.box_download_insecure = true
#  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.provision "shell" do |s|
    ssh_pub_key = File.readlines("/home/rmitrev/.ssh/id_rsa.pub").first.strip
    s.inline = <<-SHELL
    echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
    echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
    SHELL
  end


  (1..LoadBalancerCount).each do |i|

    config.vm.define "loadbalancer#{i}" do |lb|

      lb.vm.box               = VAGRANT_BOX
      lb.vm.box_check_update  = false
      lb.vm.box_version       = VAGRANT_BOX_VERSION
      lb.vm.hostname          = "loadbalancer#{i}.example.com"

      lb.vm.network "private_network", ip: "172.18.18.5#{i}"

      lb.vm.provider :virtualbox do |v|
        v.name   = "loadbalancer#{i}"
        v.memory = 512
        v.cpus   = 1
      end

      lb.vm.provider :libvirt do |v|
        v.memory  = 512
		v.nested  = true
        v.cpus    = 1
      end
       	
		lb.vm.provision "shell", path: "bootstrap-simple.sh"
    end
  end
  
  
  # Kubernetes Master Server
  config.vm.define "libmaster" do |node|
  
    node.vm.box               = VAGRANT_BOX
    node.vm.box_check_update  = false
    node.vm.box_version       = VAGRANT_BOX_VERSION
    node.vm.hostname          = "libmaster.example.com"

    node.vm.network "private_network", ip: "172.18.18.110"
  
    node.vm.provider :virtualbox do |v|
      v.name    = "libmaster"
      v.memory  = MEMORY_MASTER_NODE
      v.cpus    = CPUS_MASTER_NODE
    end
  
    node.vm.provider :libvirt do |v|
      v.memory  = MEMORY_MASTER_NODE
      v.nested  = true
      v.cpus    = CPUS_MASTER_NODE
    end
    node.vm.provision "shell", path: "bootstrap.sh"
    node.vm.provision "shell", path: "bootstrap_kmaster.sh"
  
  end

  # Kubernetes additional  Nodes 172.18.18.12#
  (1..ADD_NODES_COUNT).each do |i|

    config.vm.define "libmaster#{i}" do |node|

      node.vm.box               = VAGRANT_BOX
      node.vm.box_check_update  = false
      node.vm.box_version       = VAGRANT_BOX_VERSION
      node.vm.hostname          = "libmaster#{i}.example.com"

      node.vm.network "private_network", ip: "172.18.18.12#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "libmaster#{i}"
        v.memory  = MEMORY_WORKER_NODE
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provider :libvirt do |v|
        v.memory  = MEMORY_WORKER_NODE
        v.nested  = true
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provision "shell", path: "bootstrap.sh"
     end
    end


  # Kubernetes Worker Nodes
  (1..WORKER_NODES_COUNT).each do |i|

    config.vm.define "libworker#{i}" do |node|

      node.vm.box               = VAGRANT_BOX
      node.vm.box_check_update  = false
      node.vm.box_version       = VAGRANT_BOX_VERSION
      node.vm.hostname          = "libworker#{i}.example.com"

      node.vm.network "private_network", ip: "172.18.18.11#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "libworker#{i}"
        v.memory  = MEMORY_WORKER_NODE
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provider :libvirt do |v|
        v.memory  = MEMORY_WORKER_NODE
        v.nested  = true
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provision "shell", path: "bootstrap.sh"
      node.vm.provision "shell", path: "bootstrap_kworker.sh"

    end

  end

end
