#!/bin/bash

apt update
apt install apache2 -y

service apache2 restart

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers

cat > /etc/apache2/sites-available/reverse-proxy.conf << 'CONF'
<VirtualHost *:80>
    ServerName k31.com
    ServerAlias www.k31.com penny.k31.com

    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}

    <Proxy "balancer://backend">
        BalancerMember http://10.79.1.4
        BalancerMember http://10.79.1.5
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://backend/
    ProxyPassReverse / balancer://backend/
</VirtualHost>
CONF

a2dissite 000-default.conf
a2ensite reverse-proxy.conf

apache2ctl configtest
service apache2 restart