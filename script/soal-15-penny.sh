#!/bin/bash
set -e

apt update || true
apt install php-fpm -y

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers proxy_fcgi

PHPV=$(ls /usr/sbin/php-fpm* 2>/dev/null | head -1 | grep -o '[0-9]\.[0-9]' | head -1)

if [ -z "$PHPV" ]; then
    echo "Versi PHP-FPM tidak ditemukan."
    exit 1
fi

echo "Versi PHP terdeteksi: $PHPV"

service "php${PHPV}-fpm" start || "php-fpm${PHPV}" -D

sleep 2

ls /run/php/

mkdir -p /var/www/eternal

cat > /var/www/eternal/index.php << 'PHP'
<?php
echo "eternal jalan, PHP " . phpversion();
PHP

chown -R www-data:www-data /var/www/eternal

mkdir -p /var/www/admin

[ -f /var/www/admin/index.html ] || \
echo "halaman admin" > /var/www/admin/index.html

cat > /etc/apache2/sites-available/reverse-proxy.conf << 'CONF'
<VirtualHost *:80>
    ServerName www.k31.com
    ServerAlias k31.com

    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    ProxyPass /admin !
    Alias /admin /var/www/admin

    <Directory /var/www/admin>
        AuthType Basic
        AuthName "Admin Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Directory>

    ProxyPass /eternal !
    Alias /eternal /var/www/eternal

    <Directory /var/www/eternal>
        Require all granted
        DirectoryIndex index.php index.html

        <FilesMatch "\.php$">
            SetHandler "proxy:unix:/run/php/phpPHPV-fpm.sock|fcgi://localhost"
        </FilesMatch>
    </Directory>

    <Proxy "balancer://backend">
        BalancerMember http://10.79.1.4
        BalancerMember http://10.79.1.5
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://backend/
    ProxyPassReverse / balancer://backend/
</VirtualHost>
CONF

sed -i "s/phpPHPV-fpm/php${PHPV}-fpm/" \
/etc/apache2/sites-available/reverse-proxy.conf

a2ensite reverse-proxy.conf 2>/dev/null || true

apache2ctl configtest

pkill apache2 || true

sleep 2

apache2ctl start

echo "--- SELESAI ---"

grep -n "SetHandler" \
/etc/apache2/sites-available/reverse-proxy.conf

curl -s -H "Host: www.k31.com" \
http://localhost/eternal/index.php

echo