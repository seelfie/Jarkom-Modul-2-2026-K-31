#!/bin/bash
a2enmod remoteip
a2enconf remoteip

cat > /etc/apache2/conf-available/remoteip.conf << 'EOF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.79.3.2
EOF

cat /etc/apache2/conf-available/remoteip.conf

a2enconf remoteip

VHOST=/etc/apache2/sites-available/vault.conf

grep -q "access.log" "$VHOST" || sed -i '/<\/VirtualHost>/i \    CustomLog ${APACHE_LOG_DIR}/access.log combined' "$VHOST"

cat "$VHOST"

apache2ctl configtest
apache2ctl restart