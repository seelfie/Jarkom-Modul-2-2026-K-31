#!/bin/bash

# 1. Tambah 3 reverse zone di named.conf.local
cat >> /etc/bind/named.conf.local <<'EOF'

zone "1.79.10.in-addr.arpa" {
   type master;
   file "/etc/bind/zones/1.79.10.in-addr.arpa";
   notify yes;
   also-notify { 10.79.1.3; };
   allow-transfer { 10.79.1.3; };
};

zone "2.79.10.in-addr.arpa" {
   type master;
   file "/etc/bind/zones/2.79.10.in-addr.arpa";
   notify yes;
   also-notify { 10.79.1.3; };
   allow-transfer { 10.79.1.3; };
};

zone "3.79.10.in-addr.arpa" {
   type master;
   file "/etc/bind/zones/3.79.10.in-addr.arpa";
   notify yes;
   also-notify { 10.79.1.3; };
   allow-transfer { 10.79.1.3; };
};
EOF

# 2. Reverse zone 10.79.1.x (vault dan core)
cat > /etc/bind/zones/1.79.10.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026093001 604800 86400 2419200 604800 )
@       IN      NS      prab.K31.com.
@       IN      NS      tedd.K31.com.
4       IN      PTR     vault.K31.com.
5       IN      PTR     vault.K31.com.
6       IN      PTR     core.K31.com.
7       IN      PTR     core.K31.com.
EOF

# 3. Reverse zone 10.79.2.x (abbey)
cat > /etc/bind/zones/2.79.10.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026093001 604800 86400 2419200 604800 )
@       IN      NS      prab.K31.com.
@       IN      NS      tedd.K31.com.
2       IN      PTR     abbey.K31.com.
EOF

# 4. Reverse zone 10.79.3.x (penny)
cat > /etc/bind/zones/3.79.10.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026093001 604800 86400 2419200 604800 )
@       IN      NS      prab.K31.com.
@       IN      NS      tedd.K31.com.
2       IN      PTR     penny.K31.com.
EOF

# 5. Cek sintaks lalu restart
named-checkconf && \
named-checkzone 1.79.10.in-addr.arpa /etc/bind/zones/1.79.10.in-addr.arpa && \
named-checkzone 2.79.10.in-addr.arpa /etc/bind/zones/2.79.10.in-addr.arpa && \
named-checkzone 3.79.10.in-addr.arpa /etc/bind/zones/3.79.10.in-addr.arpa && \
service named restart
