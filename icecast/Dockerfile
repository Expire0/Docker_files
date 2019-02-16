FROM alpine:latest
LABEL maintainer Expire0 <<>@gmail.com>


RUN addgroup -S icecast && \
    adduser -S icecast

RUN apk add --update \
        icecast
CMD rm -rf /var/cache/apk/*

COPY icecast.xml /etc/icecast.xml

EXPOSE 8000
VOLUME ["/var/log/icecast"]
CMD icecast -c /etc/icecast.xml
