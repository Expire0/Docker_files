Run the images 
docker create volume demo
docker run -d -v demo:/etc/ -p 8000:8000 demo:icecast


inspired by https://hub.docker.com/r/infiniteproject/icecast

