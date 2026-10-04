# prab
ZONE=/etc/bind/zones/K31.com

grep -q "IN TXT" $ZONE || cat >> $ZONE << 'EOF'
alpha   IN      TXT     "alpha"
beta    IN      TXT     "beta"
gamma   IN      TXT     "gamma"
delta   IN      TXT     "delta"
epsilon IN      TXT     "epsilon"
EOF

sed -i -E 's/2026093001([[:space:]]*; serial)/2026093002\1/' $ZONE

tail -n 12 $ZONE
grep -n serial $ZONE
named-checkzone K31.com $ZONE
rndc reload || { pkill named; sleep 1; named; }

# pengecekan
for h in alpha beta gamma delta epsilon; do nslookup -type=TXT $h.k31.com 10.79.1.2 | grep text; done
nslookup -type=TXT alpha.k31.com 10.79.1.3 | grep text
