FROM ansible/centos7-ansible:stable
# or, for example, FROM ansible/ubuntu14.04-ansible:stable


# Add playbooks to the Docker image
ADD site.yml /srv/example/
WORKDIR /srv/example
#ssh-keygen -A

RUN echo 0000 | passwd root --stdin && yum -y install sshpass openssh-server &&  ssh-keygen -A
# Run Ansible to configure the Docker image
#RUN ansible-playbook site.yml -c local
#CMD ["/usr/sbin/sshd"]
# Other Dockerfile directives are still valid
#EXPOSE 22 3000 80
#ENTRYPOINT ["/usr/local/bin/apachectl", "-DFOREGROUND"]
ENTRYPOINT /usr/sbin/sshd && bash
