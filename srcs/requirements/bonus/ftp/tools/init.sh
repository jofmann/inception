#!/bin/sh

FTP_USER_PW=$(cat /run/secrets/ftp_user_password)

adduser -D -s /sbin/nologin ${FTP_USER}

echo "${FTP_USER}:${FTP_USER_PW}" | chpasswd

adduser ${FTP_USER} xfs

chmod -R g+w /var/www/html

envsubst '${DOMAIN_NAME}' < /etc/vsftpd/vsftpd.conf.template > /etc/vsftpd/vsftpd.conf

exec vsftpd /etc/vsftpd/vsftpd.conf
