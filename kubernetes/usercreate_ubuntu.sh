groupadd docker
userdel -r mini
useradd mini
passwd mini
usermod -aG docker,admin mini && newgrp docker
