# Di area vault:
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

# Di area core:
cat > /etc/nginx/conf.d/remoteip.conf << 'EOF'
set_real_ip_from 10.79.2.2;
real_ip_header X-Real-IP;
EOF

cat /etc/nginx/conf.d/remoteip.conf
nginx -t
nginx -s reload

# tes di alpha 
for i in 1 2 3 4 5 6; do curl -s -H "Host: www.k31.com" http://10.79.3.2/; echo; done
for i in 1 2 3 4 5 6; do curl -s -H "Host: www.k31.com" http://10.79.2.2/; echo; done

# Cek di area vault:
tail /var/log/apache2/access.log 

# Cek di area core:
tail /var/log/nginx/access.log 