## This was created for Centos7-8/Fedora 
## Expire0 for openkb.org 
## https://kubernetes.io/docs/setup/minikube/#quickstart
## error https://github.com/kubernetes/kubernetes/issues/43805
##sed -i 's#Environment="KUBELET_KUBECONFIG_ARGS=-.*#Environment="KUBELET_KUBECONFIG_ARGS=--kubeconfig=/etc/kubernetes/kubelet.conf --require-kubeconfig=true --cgroup-driver=systemd"#g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
## add this to the install https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository
read -p "run the usercreate.sh script first...Press [Enter] key to start the minikube install..."

## to be removed 
#echo "updating the system cache and applications"
#yum -y update 

#echo "installing docker ce "
#yum install -y yum-utils \
	#  device-mapper-persistent-data \
	#  lvm2
# yum-config-manager \
	#    --add-repo \
	#    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y dnf

dnf remove -y docker \
	                  docker-common \
			                    docker-selinux \
					                      docker-engine \
							      echo "remove buildah and podman"
dnf remove -y podman buildah


dnf install -y dnf-plugins-core \
	  device-mapper-persistent-data \
	    lvm2

echo "installing the kvm driver"
dnf install -y libvirt-daemon-kvm qemu-kvm
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo systemctl status libvirtd.service
#newgrp libvirt
usermod -a -G libvirt $(whoami)




curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 \
	  && sudo install docker-machine-driver-kvm2 /usr/local/bin/


echo "preparing docker repo"
dnf install -y 'dnf-command(config-manager)'
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

dnf config-manager  --enable  docker-ce-nightly
dnf -y install docker-ce docker-ce-cli containerd.io   
  

#download the latest minikube 
echo "Installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
	  && chmod +x minikube

cp minikube /bin && rm minikube
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

dnf -y install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Set SELinux in permissive mode (effectively disabling it)
echo "Reconfiguring Selinux"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

systemctl enable --now kubelet

systemctl enable docker 
systemctl start docker
echo "pausing for 10 seconds . stopping Docker"
sleep 10
systemctl stop docker
echo "pausing for 60 seconds . starting Docker"
sleep 1m
systemctl start docker
echo "finalizing"
#usermod -aG docker,wheel mini && newgrp docker
minikube delete
#su - mini 
#minikube start --vm-driver=docker
echo "Type exit to finish the installation: Remember to only start minikube using the user mini: minikube start --vm-driver=docker"

echo "installling kubens and kubectx"
sudo git clone https://github.com/ahmetb/kubectx.git
sudo cp kubectx/kubectx /usr/local/bin/ && chmod +x /usr/local/bin/kubectx
sudo cp kubectx/kubens /usr/local/bin/  && chmod +x /usr/local/bin/kubens

#    to run kubectl as a none root user . run this as that user
#    ▪ sudo mv /root/.kube /user/.minikube $HOME
#    ▪ sudo chown -R $USER $HOME/.kube $HOME/.minikube

echo "Installing Helm"
wget https://get.helm.sh/helm-v3.5.3-linux-amd64.tar.gz
tar -zxvf helm-v3.5.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm repo add stable https://charts.helm.sh/stable
echo "Completed: Remember to only start minikube using the user mini: minikube start --vm-driver=docker"
su - mini
