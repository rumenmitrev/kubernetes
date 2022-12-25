#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.18.18.110 --pod-network-cidr=192.168.0.0/16 --upload-certs >> /root/kubeinit.log 2>/dev/null
#kubeadm init --apiserver-advertise-address=172.18.18.110 --pod-network-cidr=192.168.0.0/16 --upload-certs --control-plane-endpoint=172.18.18.200

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.2/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 5] setup bash completion kubectl and kubeconnfig"
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc

echo "[TASK 6] mount Nfs and "
mkdir ~/pub
echo "172.18.18.1:/home/rmitrev/Public /root/pub nfs      defaults    0       0" >> /etc/fstab
