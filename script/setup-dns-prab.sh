#!/bin/bash
mkdir -p /etc/bind/zones

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
    type master;
    file "/etc/bind/zones/K31.com";
    notify yes;
    also-notify { 10.79.1.3; };
    allow-transfer { 10.79.1.3; };
};
EOF

cat > /etc/bind/zones/K31.com <<'EOF'
$TTL 604800
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026092901      ; serial
                        604800
                        86400
                        2419200
                        604800 )

@       IN      NS      prab.K31.com.
@       IN      NS      tedd.K31.com.

prab    IN      A       10.79.1.2
tedd    IN      A       10.79.1.3
@       IN      A       10.79.3.2
EOF

named-checkconf && named-checkzone K31.com /etc/bind/zones/K31.com && service named restart
