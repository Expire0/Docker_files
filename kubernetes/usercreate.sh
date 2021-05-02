userdel -r mini
useradd mini
passwd mini
usermod -aG docker,wheel mini && newgrp docker
