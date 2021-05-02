## This was created for Centos7/Fedora 
## Expire0 for openkb.org 
## https://kubernetes.io/docs/setup/minikube/#quickstart
## error https://github.com/kubernetes/kubernetes/issues/43805
##sed -i 's#Environment="KUBELET_KUBECONFIG_ARGS=-.*#Environment="KUBELET_KUBECONFIG_ARGS=--kubeconfig=/etc/kubernetes/kubelet.conf --require-kubeconfig=true --cgroup-driver=systemd"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
## add this to the install https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository

echo "updating the system cache and applications"
 apt-get -y remove docker docker-engine docker.io containerd runc
 apt-get -y update
 
 apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   apt-key fingerprint 0EBFCD88
   
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
  apt-get -y update
  apt-get install -y docker-ce docker-ce-cli containerd.io
  

#download the latest minikube 
echo "Installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

cp minikube /usr/local/bin && rm minikube

echo "setting up kubectl"

sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -y update
sudo apt-get install -y kubectl
apt -y autoremove

echo "Installing Helm"
wget https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz
tar -zxvf helm-v3.5.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm repo add stable https://charts.helm.sh/stable

minikube delete
echo " user minikube start --vm-driver=docker to start minikube"
su - mini
