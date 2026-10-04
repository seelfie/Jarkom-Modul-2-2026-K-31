#!/bin/bash
ss -tlnp | grep :80
which nginx

cat > /etc/nginx/conf.d/realip-log.conf << 'CONF'
log_format realip 'Host=$host X-Real-IP=$http_x_real_ip dari=$remote_addr request="$request" $status';
access_log /var/log/nginx/realip.log realip;
CONF

nginx -t && { nginx 2>/dev/null || nginx -s reload; }