# prab
cat > /root/soal-19.sh << 'EOF'
#!/bin/bash
ZONE=/etc/bind/zones/K31.com
TEDD=10.79.1.3

cp $ZONE /root/K31.com.bak

grep -q "^outbound" $ZONE || echo "outbound IN CNAME http.badssl.com." >> $ZONE

OLD=$(grep -m1 "serial" $ZONE | grep -oE '[0-9]{10}')
NEW=$((OLD+1))
sed -i "s/$OLD/$NEW/" $ZONE
echo "serial: $OLD -> $NEW"

named-checkzone K31.com $ZONE || { cp /root/K31.com.bak $ZONE; echo "Zona error, dibatalkan"; exit 1; }
rndc reload

for i in $(seq 1 10); do
  [ "$(dig +short SOA k31.com @$TEDD | awk '{print $3}')" = "$NEW" ] && { echo "tedd sinkron ($NEW)"; break; }
  sleep 1
done

echo "--- prab:"; dig +noall +answer outbound.k31.com @127.0.0.1
echo "--- tedd:"; dig +noall +answer outbound.k31.com @$TEDD
EOF

bash /root/soal-19.sh

# melakukan tes di alpha

nslookup outbound.k31.com
curl -s http://outbound.k31.com
curl -s http://http.badssl.com
