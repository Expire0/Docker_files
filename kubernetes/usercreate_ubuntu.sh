groupadd docker
userdel -r mini
useradd -m  mini
passwd mini
usermod -aG docker,admin mini && newgrp docker
