#!/bin/bash

echo "=================================="
echo "forbid swap"
echo "=================================="
sudo swapoff -a
sudo sed -i '/\/swapfile/s/^/#/' /etc/fstab
# ==================================

echo "=================================="
echo "install essential dependencies"
echo "=================================="
sudo apt-get install -y apt-transport-https ca-certificates curl containerd
# ==================================

echo "=================================="
echo create keyrings
echo "=================================="
sudo mkdir -p /etc/apt/keyrings
sudo chmod 755 /etc/apt/keyrings
# ==================================

echo "=================================="
echo "add GPG key into APT"
echo "=================================="
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# ==================================

echo "=================================="
echo "add kubernetes into apt sourcelist"
echo "=================================="
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
cat /etc/apt/sources.list.d/kubernetes.list
# ==================================

echo "=================================="
echo "update the list"
echo "=================================="
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
# ==================================

echo "=================================="
echo "hold the version of kubelet kubeadm kubectl"
echo "=================================="
sudo apt-mark hold kubelet kubeadm kubectl
kubectl version --client
kubelet --version
kubeadm version
# ==================================

echo "=================================="
echo "init kubeadm"
echo "=================================="
sudo sysctl -w net.ipv4.ip_forward=1
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
# ==================================

echo "=================================="
echo "apply flannel"
echo "=================================="
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
# ==================================

echo "=================================="
echo "create harbor-secret"
echo "=================================="
kubectl create secret docker-registry harbor-secret \
    --docker-server=$HARBOR_IP \
    --docker-username=$HARBOR_USERNAME \
    --docker-password=$HARBOR_PASSWORD \
    --docker-email=$EMAIL_ADDR
# ==================================

echo "=================================="
echo "check all the node and secret"
echo "=================================="
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get secret harbor-secret --output=yaml
# ==================================

# echo ==================================
# echo if you want to use kubectl command in specific user
# echo please use the command below
# echo ==================================

# echo "mkdir -p $HOME/.kube"
# echo sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# echo sudo chown $(id -u):$(id -g) $HOME/.kube/config
