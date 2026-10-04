#!/bin/bash

# 1. Install nginx dan PHP-FPM
apt-get update && apt-get install -y nginx php-fpm
 
# 2. Deteksi versi PHP otomatis (mis. 8.4)
PHPVER=$(ls /etc/php/ | sort -V | tail -n 1)
echo "Versi PHP terdeteksi: $PHPVER"
 
# 3. Start PHP-FPM dan cek socket
service php${PHPVER}-fpm start
service php${PHPVER}-fpm status
ls /run/php
 
# 4. Buat aplikasi
mkdir -p /var/www/core
 
cat > /var/www/core/index.php <<'EOF'
<?php
echo "<h1>Beranda</h1>";
echo "<p>Selamat datang di " . gethostname() . "</p>";
echo "<a href='/profil'>Lihat Profil</a>";
EOF
 
cat > /var/www/core/profil.php <<'EOF'
<?php
echo "<h1>Profil</h1>";
echo "<p>Ini halaman profil dari " . gethostname() . "</p>";
echo "<a href='/'>Kembali ke Beranda</a>";
EOF
 
chown -R www-data:www-data /var/www/core
chmod -R 755 /var/www/core
 
# 5. Konfigurasi nginx (rewrite /profil -> profil.php)
cat > /etc/nginx/sites-available/core.conf <<EOF
server {
   listen 80;
   server_name core.K31.com;
 
   root /var/www/core;
   index index.php index.html;
 
   rewrite ^/profil/?\$ /profil.php last;
 
   location / {
       try_files \$uri \$uri/ =404;
   }
 
   location ~ \.php\$ {
       include snippets/fastcgi-php.conf;
       fastcgi_pass unix:/run/php/php${PHPVER}-fpm.sock;
   }
}
EOF
 
# 6. Aktifkan site, nonaktifkan default
ln -sf /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/core.conf
rm -f /etc/nginx/sites-enabled/default
 
# 7. Cek syntax lalu restart
nginx -t
service nginx restart
