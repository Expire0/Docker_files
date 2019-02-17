## This was created for Centos7/Fedora 
## Expire0 for openkb.org 
## https://kubernetes.io/docs/setup/minikube/#quickstart
## error https://github.com/kubernetes/kubernetes/issues/43805
##sed -i 's#Environment="KUBELET_KUBECONFIG_ARGS=-.*#Environment="KUBELET_KUBECONFIG_ARGS=--kubeconfig=/etc/kubernetes/kubelet.conf --require-kubeconfig=true --cgroup-driver=systemd"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
## add this to the install https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository

echo "installing docker ce "
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
 yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
 yum -y install docker-ce docker-ce-cli containerd.io   
  

#download the latest minikube 
echo "Installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

cp minikube /usr/local/bin && rm minikube
echo "setting up kubectl"

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
yum -y install   kubectl --disableexcludes=kubernetes

# Set SELinux in permissive mode (effectively disabling it)
echo "Reconfiguring Selinux"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

systemctl enable --now kubelet

passwd 
minikube delete
minikube start --vm-driver=none
