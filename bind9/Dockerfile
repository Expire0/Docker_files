FROM alpine:latest
EXPOSE 53 53/udp

RUN apk --update upgrade && apk add bind 
RUN apk add bind-tools

# /etc/bind needs to be owned by root, group owned by "bind", and chmod 750
# since we are mounting, do it manually
# NOTE: Per Dockerfile manual --> need to mkdir the mounted dir to chown
# &
# /var/bind needs to be owned by root, group owned by "bind", and chmod 770
# since we are mounting, do it manually
# NOTE: Per Dockerfile manual --> need to mkdir the mounted dir to chown
# &
# Get latest bind.keys
RUN mkdir -m 0770 -p /etc/bind && chown -R root:named /etc/bind ; \
    mkdir -m 0770 -p /var/cache/bind && chown -R root:named /var/cache/bind ; \
    rndc-confgen -a 

COPY configs/. /etc/bind/
#COPY named/. /etc/bind/
COPY data/named/. /var/cache/bind/
# Mounts
# NOTE: Per Dockerfile manual -->
#	"if any build steps change the data within the volume
# 	 after it has been declared, those changes will be discarded."
VOLUME ["/etc/bind"]
VOLUME ["/var/cache/bind"]

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
