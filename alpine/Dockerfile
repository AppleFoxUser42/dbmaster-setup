FROM alpine:latest

RUN apk update && apk add mysql-client 

COPY entrypoint/setup-master.sh /usr/local/bin/
COPY entrypoint/wait-for-it.sh /usr/local/bin/

ENTRYPOINT ["setup-master.sh"]
