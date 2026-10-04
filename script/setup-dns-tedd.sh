#!/bin/bash

cat > /etc/bind/named.conf.options <<'EOF'
options {
        directory "/var/cache/bind";
        forwarders { 192.168.122.1; };
        allow-query { any; };
        recursion yes;
        dnssec-validation no;
        listen-on { any; };
};
EOF

cat >> /etc/bind/named.conf.local <<'EOF'
zone "K31.com" {
    type slave;
    masters { 10.79.1.2; };
    file "/var/cache/bind/db.K31.com";
};
EOF

named-checkconf && service named restart
