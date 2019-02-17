## This was created for Centos/Fedora 
## error https://github.com/kubernetes/kubernetes/issues/43805
##sed -i 's#Environment="KUBELET_KUBECONFIG_ARGS=-.*#Environment="KUBELET_KUBECONFIG_ARGS=--kubeconfig=/etc/kubernetes/kubelet.conf --require-kubeconfig=true --cgroup-driver=systemd"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
## add this to the install https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository


echo "installing docker"
yum -y install docker 
systemctl enable docker 
systemctl start docker 


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

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y   kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

passwd 
minikube delete
minikube start --vm-driver=none
