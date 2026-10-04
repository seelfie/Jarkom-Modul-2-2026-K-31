#!/bin/bash

apt update
apt install apache2-utils -y

htpasswd -cb /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'

cat /etc/apache2/.htpasswd

mkdir -p /var/www/admin
echo "halaman admin" > /var/www/admin/index.html

cat > /etc/apache2/sites-available/reverse-proxy.conf << 'EOF'
<VirtualHost *:80>
    ServerName k31.com
    ServerAlias www.k31.com penny.k31.com

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

    <Proxy "balancer://backend">
        BalancerMember http://10.79.1.4
        BalancerMember http://10.79.1.5
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://backend/
    ProxyPassReverse / balancer://backend/
</VirtualHost>
EOF

apache2ctl configtest
apache2ctl restart