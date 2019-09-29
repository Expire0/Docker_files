docker exec -it jupyterlab_juypter_1 passwd mas

#clean local host file 
for i in $(docker inspect jupyterlab_nginx-proxy_1 | grep "\"IPAddress\": \"172*" | egrep -o "[0-9]{3}.*[0-3]") ; do sed -i '/172.19/d' /etc/hosts &&  echo "$i juy.local" >> /etc/hosts ; done
