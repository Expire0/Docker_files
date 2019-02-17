## This was created for Centos/Fedora 

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
EOF
yum install -y kubectl

passwd 
minikube delete
minikube start --vm-driver=none
