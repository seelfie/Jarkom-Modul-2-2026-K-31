# penny
<VirtualHost *:80>
    ServerName penny.k31.com
    ServerAlias 10.79.3.2
    Redirect permanent / http://www.k31.com/
</VirtualHost>


sed -i 's|ServerName k31.com|ServerName www.k31.com|; s|ServerAlias www.k31.com|ServerAlias k31.com|' /etc/apache2/sites-available/reverse-proxy.conf
grep -n "Server" /etc/apache2/sites-available/reverse-proxy.conf

a2ensite 000-redirect.conf
apache2ctl configtest
apache2ctl restart
apache2ctl -S 2>/dev/nul

# abbey
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