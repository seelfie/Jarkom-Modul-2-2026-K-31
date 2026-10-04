# prab
which unbound
pgrep -a unbound
ss -ulnp | grep 5353

cat > /etc/unbound/unbound.conf.d/lab.conf << 'EOF'
server:
    interface: 127.0.0.1
    port: 5353
    access-control: 127.0.0.0/8 allow
    do-not-query-localhost: no
    domain-insecure: "K31.com"
    auto-trust-anchor-file: ""

forward-zone:
    name: "K31.com"
    forward-addr: 127.0.0.1
EOF

sed -i 's|^[[:space:]]*auto-trust-anchor-file:.*|# auto-trust-anchor-file: "/var/lib/unbound/root.key"|' /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf

#!/bin/bash
# bash soal-18.sh 
# bash soal-18.sh balik        
ZONE=/etc/bind/zones/K31.com
OLDIP=10.79.2.2
TEDD=10.79.1.3
ARG="${1:-10.79.8.8}"

restart_resolver() {
  pkill unbound 2>/dev/null
  sleep 1
  unbound
  sleep 1
}

ubah() {
  cp $ZONE /root/K31.com.bak
  sed -i -E "s/^abbey[[:space:]].*/abbey   15  IN  A   $1/" $ZONE
  sed -i -E "s/^static[[:space:]].*/static  15  IN  CNAME abbey.K31.com./" $ZONE
  OLD=$(grep -m1 "serial" $ZONE | grep -oE '[0-9]{10}')
  NEW=$((OLD+1))
  sed -i "s/$OLD/$NEW/" $ZONE
  echo "abbey -> $1 | serial: $OLD -> $NEW"
  named-checkzone K31.com $ZONE >/dev/null || { echo "Zona error, dibatalkan"; cp /root/K31.com.bak $ZONE; exit 1; }
  rndc reload >/dev/null 2>&1 || { pkill named; sleep 1; named; }
  for i in $(seq 1 10); do
    [ "$(dig +short SOA k31.com @$TEDD | awk '{print $3}')" = "$NEW" ] && { echo "tedd sinkron (serial $NEW)"; return; }
    sleep 1
  done
  echo "PERINGATAN: tedd belum sinkron, jalankan di tedd: rndc retransfer K31.com"
}

cek() {
  date
  echo "-- resolver cache:"
  dig +noall +answer -p 5353 abbey.k31.com @127.0.0.1
  echo "-- serial prab: $(dig +short SOA k31.com @127.0.0.1 | awk '{print $3}')  tedd: $(dig +short SOA k31.com @$TEDD | awk '{print $3}')"
}

if [ "$ARG" = "balik" ]; then
  ubah $OLDIP
  restart_resolver
  cek
  exit 0
fi

NEWIP="$ARG"
[[ $NEWIP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || { echo "Format IP salah: $NEWIP"; exit 1; }
for o in ${NEWIP//./ }; do [ "$((10#$o))" -le 255 ] || { echo "Oktet > 255: $NEWIP"; exit 1; }; done

echo "# PERSIAPAN: #"
ubah $OLDIP
sleep 16
restart_resolver

echo; echo "# FASE 1: sebelum perubahan (cache terisi IP lama) #"
cek
sleep 1

echo; echo "# UBAH ke $NEWIP #"
ubah $NEWIP

echo; echo "# FASE 2: perubahan baru terjadi, dalam jeda 15 detik (cache MASIH IP lama) #"
sleep 5
cek

echo; echo "# FASE 3: setelah 15 detik habis (cache kedaluwarsa, IP baru) #"
sleep 16
cek
