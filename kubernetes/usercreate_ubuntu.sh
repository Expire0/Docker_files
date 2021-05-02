groupadd docker
userdel -r mini
useradd -d /home/mini mini
passwd mini
usermod -aG docker,admin mini && newgrp docker
