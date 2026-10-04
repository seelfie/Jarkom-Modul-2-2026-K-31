#!/bin/bash

# Timpa named.conf.local di tedd (K31.com + 3 reverse zone sebagai slave)
cat > /etc/bind/named.conf.local <<'EOF'
zone "K31.com" {
    type slave;
    masters { 10.79.1.2; };
    file "/var/cache/bind/db.K31.com";
};

zone "1.79.10.in-addr.arpa" {
    type slave;
    masters { 10.79.1.2; };
    file "/var/cache/bind/db.1.79.10";
};

zone "2.79.10.in-addr.arpa" {
    type slave;
    masters { 10.79.1.2; };
    file "/var/cache/bind/db.2.79.10";
};

zone "3.79.10.in-addr.arpa" {
    type slave;
    masters { 10.79.1.2; };
    file "/var/cache/bind/db.3.79.10";
};
EOF

named-checkconf && service named restart

sleep 3 
for z in 1 2 3; do rndc zonestatus $z.79.10.in-addr.arpa | head -3; done 
