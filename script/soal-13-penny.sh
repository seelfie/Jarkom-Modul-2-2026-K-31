#!/bin/bash
cat > /etc/apache2/sites-available/000-redirect.conf << 'EOF'
<VirtualHost *:80>
    ServerName penny.k31.com
    ServerAlias 10.79.3.2
    Redirect permanent / http://www.k31.com/
</VirtualHost>
EOF

sed -i 's|ServerName k31.com|ServerName www.k31.com|; s|ServerAlias www.k31.com|ServerAlias k31.com|' /etc/apache2/sites-available/reverse-proxy.conf

grep -n "Server" /etc/apache2/sites-available/reverse-proxy.conf

a2ensite 000-redirect.conf

apache2ctl configtest

apache2ctl restart

apache2ctl -S 2>/dev/null