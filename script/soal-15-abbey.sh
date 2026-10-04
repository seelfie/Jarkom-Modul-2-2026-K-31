#!/bin/bash
set -e

mkdir -p /var/www/orion

echo "orion statis" > /var/www/orion/index.html

cat > /var/www/orion/tes.php << 'EOF'
<?php echo "php jalan"; ?>
EOF

chmod -R a+rX /var/www/orion

cat > /etc/nginx/conf.d/reverse-proxy.conf << 'EOF'
upstream backend {
    server 10.79.1.6;
    server 10.79.1.7;
}

server {
    listen 80 default_server;
    server_name abbey.k31.com 10.79.2.2;

    return 302 http://static.k31.com$request_uri;
}

server {
    listen 80;
    server_name static.k31.com;

    location = /orion {
        return 301 /orion/;
    }

    location ^~ /orion/ {
        root /var/www;
        index index.html;

        location ~ \.php$ {
            return 403;
        }
    }

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

cat /etc/nginx/conf.d/reverse-proxy.conf

nginx -t

nginx -s reload