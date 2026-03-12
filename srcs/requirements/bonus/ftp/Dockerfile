FROM alpine:3.19

RUN apk add --no-cache vsftpd gettext

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf.template

COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh


EXPOSE 21 21100-21110

ENTRYPOINT  [ "init.sh" ]