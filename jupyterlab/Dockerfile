FROM docker.io/library/debian:latest
EXPOSE 8000

RUN apt-get  update --yes 
RUN apt-get install --yes sqlite python3 vim python3-pip npm nodejs libnode64
RUN  npm install -g configurable-http-proxy

RUN useradd  mas
RUN mkdir /srv/jupyter
WORKDIR /srv/jupyter

COPY requirements.txt /srv/jupyter/
RUN pip3 install -r requirements.txt

#RUN jupyterhub --generate-config
COPY jupyterhub_config.py /srv/jupyter/
RUN mkdir /var/tmp/mas
RUN chmod 777 /var/tmp/mas
RUN ln -s /var/tmp/mas /home/mas

RUN echo 'Remember to create a user in the container and add update the user to admin in the db'
RUN echo 'lastly update the config to set that user as admin under'
# set the default to lab c.Spawner.default_url = '/lab'
# user c.Authenticator.admin_users
#update users set admin=1 where name="mas";
#run the new image as podman run -v <volume>:/var/tmp -id -p 8000:8000 <imagename>
CMD ["jupyterhub", "-f", "/srv/jupyter/jupyterhub_config.py"]
