FROM alpine:latest
EXPOSE 8056 

RUN apk --update upgrade && apk add python3


# Mounts
# NOTE: Per Dockerfile manual -->
#	"if any build steps change the data within the volume
# 	 after it has been declared, those changes will be discarded."
VOLUME ["/var/www"]

