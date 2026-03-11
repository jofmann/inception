#!/bin/sh

FTP_PW=$(cat /run/secrets/ftp_password)

adduser -D -s /sbin/nologin ftpUser
echo "ftpUser:${FTP_PW}" | chpasswd

chown -R ftpUser:ftpUser /var/www/html

exec vsftpd