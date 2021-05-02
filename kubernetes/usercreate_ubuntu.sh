groupadd docker
userdel -r mini
useradd -m /home/mini mini
passwd mini
usermod -aG docker,admin mini && newgrp docker
