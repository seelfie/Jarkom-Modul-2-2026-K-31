echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 bind9-utils bind9-dnsutils -y
service named start
printf 'nameserver 10.79.1.2\nnameserver 10.79.1.3\nnameserver 192.168.122.1\n' > /etc/resolv.conf
