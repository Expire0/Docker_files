docker exec -it jupyterlab_juypter_1 useradd  $1
docker exec -it jupyterlab_juypter_1 passwd $1
docker exec -it jupyterlab_juypter_1 ln -s /var/tmp/$1  /home/$1
docker exec -it jupyterlab_juypter_1 chmod -R 777 /var/tmp/
