FROM ubuntu:20.04

RUN apt update && apt install -y openssh-server

COPY docker-entrypoint.sh /

EXPOSE 9022

ENTRYPOINT ["/docker-entrypoint.sh"]
