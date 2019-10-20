docker service create --name expire0_juypter --publish published=8000,target=8000,mode=host  --replicas=1 expire0:dev


test the new image using docker-compose
