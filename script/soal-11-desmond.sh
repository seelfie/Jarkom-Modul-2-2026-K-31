#!/bin/bash
apt update
apt install apache2 -y

service apache2 start

cat > /etc/apache2/conf-available/realip.conf << 'CONF'
LogFormat "Host=%{Host}i X-Real-IP=%{X-Real-IP}i dari=%h \"%r\" %>s" realip
CustomLog ${APACHE_LOG_DIR}/realip.log realip
CONF

a2enconf realip

apache2ctl configtest
service apache2 restart

echo "ini desmond" > /var/www/html/index.html