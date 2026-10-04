#!/bin/bash
cat > /etc/nginx/conf.d/remoteip.conf << 'EOF'
set_real_ip_from 10.79.2.2;
real_ip_header X-Real-IP;
EOF

cat /etc/nginx/conf.d/remoteip.conf

nginx -t

nginx -s reload