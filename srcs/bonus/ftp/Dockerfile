FROM alpine:3.19

RUN apk add --no-cache vsftpd

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh


EXPOSE 21

EXPOSE 21100-21110

ENTRYPOINT  [ "init.sh" ]