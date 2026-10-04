#!/bin/bash
printf 'options timeout:1 attempts:1\nnameserver 10.79.1.2\nnameserver 10.79.1.3\nnameserver 192.168.122.1\n' > /etc/resolv.conf

cat > /etc/hosts <<'EOF'
127.0.0.1 localhost
10.79.4.2 alpha
10.79.4.3 beta
10.79.4.4 gamma
10.79.5.2 delta
10.79.5.3 epsilon
10.79.1.2 prab
10.79.1.3 tedd
10.79.2.2 abbey
10.79.3.2 penny
10.79.1.4 obladi
10.79.1.5 desmond
10.79.1.6 oblada
10.79.1.7 molly
EOF
