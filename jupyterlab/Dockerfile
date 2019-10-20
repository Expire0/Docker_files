FROM docker.io/library/debian:latest
EXPOSE 8000

RUN apt-get  update --yes 
RUN apt-get install --yes sqlite python3 vim python3-pip npm nodejs libnode64
RUN  npm install -g configurable-http-proxy

RUN apt-get install --yes libffi-dev zlib1g-dev curl wget 

WORKDIR /root
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
RUN tar xzf Python-3.8.0.tgz
WORKDIR /root/Python-3.8.0
RUN ./configure --enable-optimizations
RUN  make altinstall

RUN useradd  mas
RUN mkdir /srv/jupyter
WORKDIR /srv/jupyter

COPY requirements.txt /srv/jupyter/
RUN pip3 install -r requirements.txt
RUN pip3.8 install ipykernel


#RUN jupyterhub --generate-config
COPY jupyterhub_config.py /srv/jupyter/
RUN mkdir /var/tmp/mas
RUN chmod 777 /var/tmp/mas
RUN ln -s /var/tmp/mas /home/mas
#TESTING SSL
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem 
COPY mycert.pem /srv/jupyter/
COPY mykey.key /srv/jupyter/

#patch so the notebook can use Python3.8
COPY kernels/python37 /usr/local/share/jupyter/kernels/
COPY kernels/python38 /usr/local/share/jupyter/kernels/

RUN echo 'Remember to create a user in the container and add update the user to admin in the db'
RUN echo 'lastly update the config to set that user as admin under'
# set the default to lab c.Spawner.default_url = '/lab'
# user c.Authenticator.admin_users
#update users set admin=1 where name="mas";
#run the new image as podman run -v <volume>:/var/tmp -id -p 8000:8000 <imagename>
CMD ["jupyterhub", "-f", "/srv/jupyter/jupyterhub_config.py"]
