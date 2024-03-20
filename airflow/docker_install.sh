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

echo "installing Docker Compose server wide"
DOCKER_CONFIG=${DOCKER_CONFIG:-/usr/local/lib/docker/}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
