#!/bin/bash

# 1. Install Apache
apt-get update && apt-get install -y apache2
 
# 2. Siapkan folder /arsip dan file contoh
mkdir -p /arsip
touch /arsip/file1.txt /arsip/file2.txt /arsip/file3.txt
chmod -R 755 /arsip
 
# 3. Buat VirtualHost
cat > /etc/apache2/sites-available/vault.conf <<'EOF'
<VirtualHost *:80>
    ServerName vault.K31.com
    DocumentRoot /var/www/html
 
    Alias /arsip /arsip
 
    <Directory /arsip>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF
 
# 4. ServerName global (hilangkan warning AH00558)
echo "ServerName vault.K31.com" > /etc/apache2/conf-available/servername.conf
a2enconf servername
 
# 5. Start Apache, aktifkan modul dan site
service apache2 start
service apache2 status
a2enmod autoindex
a2dissite 000-default.conf
a2ensite vault.conf
 
# 6. Cek syntax lalu restart
apache2ctl configtest
service apache2 restart
