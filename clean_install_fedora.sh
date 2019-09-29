#https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/centos/#install-using-the-repository
## This clean script will install Docker from Docker's official repo instead of Centos or Fedora's
##The script also removes yum and ensures DNF is installed. This is unrelated to Docker but I felt the need to do it. 


yum install dnf

dnf remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine \
                  yum \
                  yum.utils


dnf install -y dnf-plugins-core \
  device-mapper-persistent-data \
  lvm2

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

dnf config-manager  --enablerepo=docker-ce-edge


dnf -y install docker-ce docker-compose

systemctl start docker && systemctl enable docker
