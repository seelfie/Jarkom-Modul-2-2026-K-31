#!/bin/bash
apt-get update
apt-get install -y nginx

cat > /etc/nginx/conf.d/reverse-proxy.conf << 'CONF'
upstream backend {
    server 10.79.1.6;
    server 10.79.1.7;
}

server {
    listen 80 default_server;
    server_name abbey.k31.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
CONF

rm -f /etc/nginx/sites-enabled/default

nginx -t && { nginx 2>/dev/null || nginx -s reload; }
ss -tlnp | grep :80