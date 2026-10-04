# Jarkom-Modul-2-2026-K-31

| Nama | NRP |
|------|-----|
| Silfi Rochmatul Auliyah | 5027251008 |
| Nabila Sharliz Sigit | 5027251054 |

## Reporting

11. Konfigurasikan Penny (menggunakan Apache) sebagai reverse proxy yang mengarah ke semua node di area vault (Obladi & Desmond). Sementara itu, konfigurasikan Abbey (menggunakan Nginx) sebagai reverse proxy menuju area core (Oblada & Molly). Pastikan kedua gerbang ini meneruskan identitas asli pengunjung ke server backend dengan melakukan forwarding header Host dan X-Real-IP. Buktikan bahwa Penny dan Abbey berhasil mendistribusikan lalu lintas dengan tepat.

Reverse proxy adalah server perantara yang berada di depan server backend. Client tidak berhubungan langsung dengan backend, tetapi melalui proxy terlebih dahulu. Karena soal meminta traffic dibagi ke dua node, maka digunakan fitur load balancing dengan metode `byrequests` (round robin) pada Apache dan `upstream` pada Nginx.
 
Pertama-tama pada node Penny kita perlu menginstall Apache dan mengaktifkan modul proxy yang dibutuhkan.
 
```sh
apt update
apt install apache2 -y
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers
```
 
Kemudian dibuat virtual host reverse proxy pada `/etc/apache2/sites-available/reverse-proxy.conf`.
 
```sh
cat > /etc/apache2/sites-available/reverse-proxy.conf << 'EOF'
<VirtualHost *:80>
    ServerName k31.com
    ServerAlias www.k31.com penny.k31.com
 
    ProxyPreserveHost On
    RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}
 
    <Proxy "balancer://backend">
        BalancerMember http://10.79.1.4
        BalancerMember http://10.79.1.5
        ProxySet lbmethod=byrequests
    </Proxy>
 
    ProxyPass / balancer://backend/
    ProxyPassReverse / balancer://backend/
</VirtualHost>
EOF
 
a2dissite 000-default.conf
a2ensite reverse-proxy.conf
apache2ctl configtest
apache2ctl start || apache2ctl restart
```
 
- `ServerName` diisi dengan nama apex (`k31.com`) yang A record-nya sudah mengarah ke penny, sedangkan nama lain yang menuju penny dituliskan pada `ServerAlias`.
- `ProxyPreserveHost On` membuat header Host yang dikirim client diteruskan apa adanya ke backend.
- `RequestHeader set X-Real-IP expr=%{REMOTE_ADDR}` menempelkan IP asli client pada header X-Real-IP.
- `<Proxy "balancer://backend">` mengelompokkan obladi dan desmond sebagai anggota balancer, dan `ProxyPass` meneruskan semua request ke balancer tersebut.
  
Kemudian, pada node Abbey kita perlu menginstall Nginx dan mengaktifkan modul proxy yang dibutuhkan.
 
```sh
apt-get update
apt-get install -y nginx
 
cat > /etc/nginx/conf.d/reverse-proxy.conf << 'CONF'
upstream backend {
    server 10.79.1.6;
    server 10.79.1.7;
}
 
server {
    listen 80 default_server;
    server_name abbey.k31.com;
 
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
CONF
 
rm -f /etc/nginx/sites-enabled/default
nginx -t && { nginx 2>/dev/null || nginx -s reload; }
```
 
Pada Nginx, `proxy_set_header Host $host;` dan `proxy_set_header X-Real-IP $remote_addr;` memiliki fungsi yang sama dengan `ProxyPreserveHost` dan `RequestHeader` pada Apache. Nginx secara default menggunakan round robin, sehingga tidak perlu menuliskan metode balancing. 

Kemudian kita bisa menguji distribusi traffic dari node alpha. Pada backend Apache (obladi, desmond) isi halaman dibedakan lewat `index.html`, sedangkan pada oblada dan molly halaman `index.php` dari `setup-nginx.sh` sudah menampilkan hostname masing-masing, sehingga bisa dibedakan tanpa mengubah apa pun.
 
```sh
for i in 1 2 3 4 5 6; do curl -s -H "Host: k31.com" http://10.79.3.2/; echo; done
for i in 1 2 3 4 5 6; do curl -s -H "Host: abbey.k31.com" http://10.79.2.2/ | grep -o "di [a-z]*"; done
```
 
![alt text](assets/soal-11-curl-penny.png)

![alt text](assets/soal-11-curl-abbey.png)

Hasil curl bergantian antara kedua node dengan perbandingan 3:3, yang membuktikan traffic terdistribusi secara seimbang.
 
Untuk membuktikan header Host dan X-Real-IP benar-benar sampai, dibuat format log khusus pada backend. Header ditempel oleh proxy, tetapi dibaca dan dicatat oleh backend.
 
Pada obladi dan desmond (Apache):
 
```sh
cat > /etc/apache2/conf-available/realip.conf << 'CONF'
LogFormat "Host=%{Host}i X-Real-IP=%{X-Real-IP}i dari=%h \"%r\" %>s" realip
CustomLog ${APACHE_LOG_DIR}/realip.log realip
CONF

a2enconf realip

apache2ctl configtest
service apache2 restart

echo "ini obladi" > /var/www/html/index.html
```

```sh
cat > /etc/apache2/conf-available/realip.conf << 'CONF'
LogFormat "Host=%{Host}i X-Real-IP=%{X-Real-IP}i dari=%h \"%r\" %>s" realip
CustomLog ${APACHE_LOG_DIR}/realip.log realip
CONF

a2enconf realip

apache2ctl configtest
service apache2 restart

echo "ini desmond" > /var/www/html/index.html
```
 
Pada oblada dan molly (Nginx):
 
```sh
cat > /etc/nginx/conf.d/realip-log.conf << 'CONF'
log_format realip 'Host=$host X-Real-IP=$http_x_real_ip dari=$remote_addr request="$request" $status';
access_log /var/log/nginx/realip.log realip;
CONF
nginx -t && nginx -s reload
```
 
Setelah request dikirim dari alpha, log dibaca pada masing-masing backend.

Pada obladi & desmond:
```sh
tail /var/log/apache2/realip.log     
```

![alt text](assets/soal-11-log.png)

Pada oblada & molly:
```sh
tail /var/log/nginx/realip.log       
```
 
![alt text](assets/soal-11-log-nginx.png)
 
Pada log terlihat `Host=` berisi nama yang diketik client dan `X-Real-IP=` berisi IP alpha (`10.79.4.2`), sedangkan `dari=` berisi IP gerbang (penny atau abbey). 

12.   Terdapat ruang khusus di penny yang yang menyimpan dokumen rahasia sindikat, oleh karena itu terapkan perlindungan basic authentication untuk path /admin. Akses ke jalur tersebut harus menolak pengunjung tanpa kredensial, dan hanya mengizinkan masuk jika menggunakan credential berikut:
| username | password |
|------|-----|
| prabs | pakar_pinter_jadi_gob*** |

Pada soal ini path `/admin` harus dilayani oleh penny sendiri. Jika tidak dikecualikan, `ProxyPass /` akan meneruskan `/admin` ke obladi dan desmond, sehingga autentikasi di penny tidak pernah dicek.
 
Pertama-tama dibuat file kredensial menggunakan `htpasswd`.
 
```sh
apt update
apt install apache2-utils -y
htpasswd -cb /etc/apache2/.htpasswd prabs pakar_pinter_jadi_gob***
cat /etc/apache2/.htpasswd
```

![alt text](assets/soal-12-setup-pass.png)

Isi file berupa `prabs:$apr1$...`, yaitu password yang sudah di-hash. Selanjutnya dibuat folder dan halaman untuk `/admin`.
 
```sh
mkdir -p /var/www/admin
echo "halaman admin" > /var/www/admin/index.html
```
 
Lalu blok berikut disisipkan di dalam `<VirtualHost>` pada `reverse-proxy.conf`, sebelum baris `ProxyPass / balancer://backend/`, karena Apache memakai aturan proxy yang cocok lebih dulu.
 
```sh
    ProxyPass /admin !
    Alias /admin /var/www/admin
 
    <Directory /var/www/admin>
        AuthType Basic
        AuthName "Admin Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Directory>
```
 
`ProxyPass /admin !` mengecualikan `/admin` dari proxy, kemudian `Alias` memetakan `/admin` ke folder lokal di penny. Sementara itu, `AuthType Basic`, `AuthUserFile`, dan `Require valid-user` membuat hanya user yang terdaftar di `.htpasswd` yang bisa masuk. Setelah itu konfigurasi dites dan Apache direstart.
  
```sh
apache2ctl configtest
apache2ctl restart
```
 
Kemudian, pengujian dilakukan melalui node alpha. 
 
```sh
curl -i -H "Host: k31.com" http://10.79.3.2/admin/
curl -i -u prabs:salah -H "Host: k31.com" http://10.79.3.2/admin/
curl -i -u prabs:pakar_pinter_jadi_gob*** -H "Host: k31.com" http://10.79.3.2/admin/
```

![alt text](assets/soal-12-tes-1.png)

![alt text](assets/soal-12-tes-2.png)

![alt text](assets/soal-12-tes-3.png)

Tanpa kredensial dan dengan password salah, server membalas `401 Unauthorized` dengan header `WWW-Authenticate: Basic realm="Admin Area"`. Dengan kredensial yang benar, server membalas `200 OK` dengan isi halaman admin. Path `/` tetap meneruskan request secara bergantian ke obladi dan desmond, sehingga reverse proxy tidak terganggu.
 
Pada saat pengujian sempat muncul `Password Mismatch` pada `error.log` karena password yang dikirim berbeda dengan yang di-hash pada `.htpasswd`. Masalah ini diselesaikan dengan mengatur ulang password menggunakan `htpasswd -b` (tanpa `-c` agar file tidak tertimpa).

13.  Setiap entitas dari luar harus memanggil gerbang dengan nama kanoniknya. Jika ada yang mencoba mengakses IP penny dan domain  penny.k31.com, paksa sistem untuk melakukan redirect secara permanen (status code 301) menuju www.k31.com. Sebaliknya, jika ada yang mengakses IP abbey dan domain abbey.k31.com, lakukan redirect sementara (status code 302) menuju static.k31.com.

Pada soal ini nama kanonik penny adalah `www.k31.com` dan nama kanonik abbey adalah `static.k31.com`. Akses lewat IP maupun lewat nama lain akan dialihkan ke nama kanonik tersebut. Perbedaannya, penny menggunakan redirect permanen (301) sedangkan abbey menggunakan redirect sementara (302).

Pertama-tama, kita konfigurasi node penny. Dibuat virtual host khusus yang menangkap akses lewat IP dan `penny.k31.com`, lalu dialihkan ke `www.k31.com`. Apache memakai virtual host yang dimuat paling pertama sebagai default untuk Host yang tidak cocok (termasuk akses lewat IP), maka file ini diberi nama `000-redirect.conf` supaya terurut paling awal. Setelah itu virtual host proxy diubah supaya `www.k31.com` menjadi `ServerName` dan `k31.com` menjadi alias.

```sh
#!/bin/bash
cat > /etc/apache2/sites-available/000-redirect.conf << 'EOF'
<VirtualHost *:80>
    ServerName penny.k31.com
    ServerAlias 10.79.3.2
    Redirect permanent / http://www.k31.com/
</VirtualHost>
EOF

sed -i 's|ServerName k31.com|ServerName www.k31.com|; s|ServerAlias www.k31.com|ServerAlias k31.com|' /etc/apache2/sites-available/reverse-proxy.conf

grep -n "Server" /etc/apache2/sites-available/reverse-proxy.conf

a2ensite 000-redirect.conf

apache2ctl configtest

apache2ctl restart

apache2ctl -S 2>/dev/null
```

Pada output `apache2ctl -S`, `000-redirect.conf` harus tampil sebagai default server dan `www.k31.com` sebagai virtual host proxy.

Selanjutnya kita konfigurasi node abbey. Konfigurasi Nginx ditulis ulang dengan dua blok server. Blok pertama menangkap akses lewat IP dan `abbey.k31.com` lalu mengalihkannya dengan `return 302` ke `static.k31.com`. Blok kedua melayani `static.k31.com` sebagai nama kanonik dan meneruskan request ke oblada dan molly.

```sh
#!/bin/bash
cat > /etc/nginx/conf.d/reverse-proxy.conf << 'EOF'
upstream backend {
    server 10.79.1.6;
    server 10.79.1.7;
}

server {
    listen 80 default_server;
    server_name abbey.k31.com 10.79.2.2;
    return 302 http://static.k31.com$request_uri;
}

server {
    listen 80;
    server_name static.k31.com;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

cat /etc/nginx/conf.d/reverse-proxy.conf

nginx -t

nginx -s reload
```

Parameter `default_server` membuat blok pertama menangkap request yang Host-nya tidak cocok, termasuk akses langsung lewat IP. Sedangkan `$request_uri` membawa path dan query ke tujuan, jadi `/abc` akan dialihkan ke `http://static.k31.com/abc`.

Setelah kedua gerbang dikonfigurasi, pengujian dilakukan dari node alpha dengan mencoba akses lewat IP, lewat nama lama, dan lewat nama kanonik pada masing-masing gerbang.

```sh
curl -i http://10.79.3.2/
curl -i -H "Host: penny.k31.com" http://10.79.3.2/
curl -i -H "Host: www.k31.com" http://10.79.3.2/
```

![alt text](assets/soal-13-penny-1.png)

![alt text](assets/soal-13-penny-2.png)

![alt text](assets/soal-13-penny-3.png)

```sh
curl -i http://10.79.2.2/
curl -i -H "Host: abbey.k31.com" http://10.79.2.2/
curl -i -H "Host: static.k31.com" http://10.79.2.2/
```

![alt text](assets/soal-13-abbey-1.png)

![alt text](assets/soal-13-abbey-2.png)

![alt text](assets/soal-13-abbey-3.png)

Dari gambar tersebut terlihat bahwa akses lewat IP penny dan `penny.k31.com` dibalas `301 Moved Permanently` dengan `Location: http://www.k31.com/`. Sedangkan akses lewat IP abbey dan `abbey.k31.com` dibalas `302 Moved Temporarily` dengan `Location: http://static.k31.com/`. Akses lewat nama kanonik (`www.k31.com` dan `static.k31.com`) tetap dilayani dan meneruskan request ke backend secara bergantian.

14.   Di dalam The Mesh, rekam jejak tidak boleh dipalsukan oleh sistem. Pastikan access log pada setiap server web di area vault maupun area core mencatat alamat IP asli milik client (pengunjung) yang diteruskan oleh gerbang, dan bukan mencatat IP dari Penny ataupun Abbey.

**14. Log tidak boleh dipalsukan oleh sistem. Access log pada setiap server web harus mencatat alamat IP asli client yang diteruskan oleh gerbang, bukan IP gerbang.**

Secara default backend mencatat IP koneksi langsung, yaitu IP gerbang. Agar backend mencatat IP client, backend dikonfigurasi untuk mengambil IP dari header `X-Real-IP`, tetapi hanya jika header itu datang dari gerbang yang dipercaya. Dengan begitu client lain tidak bisa memalsukan IP hanya dengan mengirim header `X-Real-IP` sendiri. Konfigurasi ini dilakukan pada backend, bukan pada penny dan abbey.

Pertama-tama kita konfigurasi area vault, yaitu obladi dan desmond yang menggunakan Apache dengan gerbang penny (`10.79.3.2`). Di sini kita gunakan modul `mod_remoteip` dengan `RemoteIPHeader` untuk menentukan header yang dibaca.

Awalnya kita memakai `RemoteIPTrustedProxy`, tetapi header tetap diabaikan. Setelah mode debug dinyalakan (`LogLevel warn remoteip:debug`), `error.log` menampilkan pesan bahwa nilai `X-Real-IP` dianggap IP private dan diabaikan. Ternyata `mod_remoteip` secara default menolak IP private, padahal semua IP di lab ini private (`10.79.x.x`). Solusinya adalah memakai `RemoteIPInternalProxy` yang menandai gerbang sebagai proxy internal, sehingga IP private dari header boleh dipercaya.

Selain itu, request di obladi dan desmond ditangani oleh virtual host `vault.K31.com` bawaan `setup-vault.sh`, yang tidak menulis ke `access.log` melainkan ke `other_vhosts_access.log`. Supaya `access.log` terisi, kita tambahkan `CustomLog` pada `vault.conf`.

```sh
#!/bin/bash
a2enmod remoteip

cat > /etc/apache2/conf-available/remoteip.conf << 'EOF'
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 10.79.3.2
EOF

cat /etc/apache2/conf-available/remoteip.conf

a2enconf remoteip

VHOST=/etc/apache2/sites-available/vault.conf

grep -q "access.log" "$VHOST" || sed -i '/<\/VirtualHost>/i \    CustomLog ${APACHE_LOG_DIR}/access.log combined' "$VHOST"

cat "$VHOST"

apache2ctl configtest
apache2ctl restart
```

Selanjutnya kita konfigurasi area core, yaitu oblada dan molly yang menggunakan Nginx dengan gerbang abbey. Nginx tidak punya pembatasan IP private seperti Apache, jadi dua baris saja sudah cukup. `set_real_ip_from` menentukan gerbang yang dipercaya dan `real_ip_header` menentukan header yang dibaca, sehingga `$remote_addr` dan `access.log` bawaan Nginx berisi IP client.

```sh
#!/bin/bash
cat > /etc/nginx/conf.d/remoteip.conf << 'EOF'
set_real_ip_from 10.79.2.2;
real_ip_header X-Real-IP;
EOF

cat /etc/nginx/conf.d/remoteip.conf

nginx -t

nginx -s reload
```

Setelah kedua area dikonfigurasi, pengujian dilakukan dari alpha (IP `10.79.4.2`) dengan mengirim request lewat penny dan abbey, kemudian log dibaca pada masing-masing backend.

```sh
for i in 1 2 3 4 5 6; do curl -s -H "Host: www.k31.com" http://10.79.3.2/; echo; done
```

![alt text](assets/soal-14-curl-penny.png)

```sh
for i in 1 2 3 4 5 6; do curl -s -H "Host: static.k31.com" http://10.79.2.2/ >/dev/null; done
```

![alt text](assets/soal-14-curl-abbey.png)

Kemudian, kita bisa melihat `access.log` pada setuap backend.
```sh
tail -n 3 /var/log/apache2/access.log   
tail -n 3 /var/log/nginx/access.log     
```

![alt text](assets/soal-14-accesslog-vault.png)

![alt text](assets/soal-14-accesslog-core.png)

Dari gambar tersebut terlihat kolom pertama pada log berisi `10.79.4.2` (IP alpha), bukan `10.79.3.2` (penny) atau `10.79.2.2` (abbey), sehingga terbukti backend mencatat IP client asli.

15.  Rootkit menginstruksikan pembuatan jalur proxy khusus yang berdiri sendiri. Pada penny buat reverse proxy untuk path /eternal yang menyajikan directory /var/www/eternal, dan pastikan path ini dapat mengeksekusi (rendering) file php. Pada abbey, buat jalur /orion yang menyajikan directory /var/www/orion, secara murni statis tanpa perlu rendering php.

16.  Ketahanan gerbang The Mesh harus diuji untuk menghadapi bombardir permintaan. Salah satu Klien (misal: Alpha) bertugas melakukan stress test benchmark menggunakan ApacheBench. Lakukan 250 requests dengan tingkat konkurensi (concurrencies) 10 untuk masing - masing titik akhir: www.xxx.com dan static.xxx.com. Tampilkan rangkuman hasilnya.

ApacheBench (`ab`) merupakan bagian dari paket `apache2-utils`, jadi pertama-tama kita install dulu pada node alpha. Selanjutnya nama `www.k31.com` dan `static.k31.com` didaftarkan pada `/etc/hosts` alpha supaya langsung mengarah ke penny dan abbey.

```sh
apt update && apt install apache2-utils -y

echo "10.79.3.2 www.k31.com" >> /etc/hosts
echo "10.79.2.2 static.k31.com" >> /etc/hosts
```

Setelah itu benchmark dijalankan dengan 250 request total (`-n 250`) dan konkurensi 10 (`-c 10`) pada masing-masing titik akhir.

```sh
ab -n 250 -c 10 http://www.k31.com/
ab -n 250 -c 10 http://static.k31.com/
```

![alt text](assets/soal-16-apache.png)

![alt text](assets/soal-16-nginx.png)

Dari hasil benchmark tersebut, ringkasan angkanya adalah sebagai berikut.

| Parameter | www.k31.com (penny) | static.k31.com (abbey) |
|---|---|---|
| Server Software | Apache/2.4.68 | nginx |
| Complete requests | 250 | 250 |
| Failed requests | 125 (semua bertipe Length) | 124 (semua bertipe Length) |
| Time taken for tests | 0.090 detik | 0.104 detik |
| Requests per second | 2789.80 | 2407.78 |
| Time per request (mean) | 3.584 ms | 4.153 ms |
| Waktu respons terlama | 8 ms | 6 ms |

Pada kedua titik akhir seluruh 250 request berhasil diselesaikan tanpa error koneksi, tanpa error penerimaan, dan tanpa exception (`Connect: 0, Receive: 0, Exceptions: 0`). Angka `Failed requests` muncul karena `ab` membandingkan panjang setiap respons dengan respons pertama, sedangkan penny dan abbey membagi request ke dua backend yang isi halamannya berbeda panjang. Jadi `Length` pada baris tersebut bukan kegagalan sebenarnya, melainkan bukti bahwa respons datang dari dua node yang berbeda.

Hal ini bisa dibuktikan dari ukuran data yang ditransfer. Pada `www.k31.com`, halaman obladi berukuran 11 byte dan halaman desmond 12 byte, sedangkan `HTML transferred` sebesar 2875 byte. Angka ini cocok dengan 125 request ke obladi dan 125 request ke desmond (125 × 11 + 125 × 12 = 2875), sehingga beban terbagi rata ke kedua node. Pada `static.k31.com`, halaman oblada dan molly berukuran 81 dan 80 byte dengan pembagian 126 dan 124 request, yang juga hampir sama rata.

Dari hasil tersebut terbukti bahwa penny dan abbey mampu menangani 250 request dengan konkurensi 10 dan membagi beban ke masing-masing backend secara seimbang.

17.  Tambahkan TXT record pada DNS untuk semua klien sayap kiri dan sayap kanan (Alpha, Beta, Gamma, Delta, Epsilon). Jika DNS di-query TXT terhadap nama domain mereka (contoh: alpha.k31.com), sistem harus mengembalikan teks berupa nama hostname mereka masing-masing (contoh: "alpha").

Sayap kiri terdiri dari alpha, beta, dan gamma, sedangkan sayap kanan terdiri dari delta dan epsilon. Record TXT ditambahkan pada zone file di prab (master) yaitu `/etc/bind/zones/K31.com`, dengan isi berupa hostname masing-masing client.

Setiap perubahan zona harus diikuti kenaikan serial pada SOA, karena tedd (slave) hanya menyalin zona kalau serial di prab lebih besar. Karena itu script membaca serial saat ini lalu menambahkannya 1, kemudian zona dicek dengan `named-checkzone` dan di-reload.

```sh
#!/bin/bash
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
```

Selanjutnya pengujian dilakukan dari node alpha dengan query TXT ke prab untuk kelima client.

```sh
for h in alpha beta gamma delta epsilon; do nslookup -type=TXT $h.k31.com 10.79.1.2 | grep text; done
nslookup -type=TXT alpha.k31.com 10.79.1.3 | grep text
```

![alt text](assets/soal-17.png)

Dari gambar tersebut terbukti bahwa query TXT terhadap `alpha.k31.com` sampai `epsilon.k31.com` mengembalikan `"alpha"`, `"beta"`, `"gamma"`, `"delta"`, dan `"epsilon"` sesuai hostname masing-masing. Query yang diarahkan ke tedd juga mengembalikan jawaban yang sama, sehingga terbukti zona sudah tersinkron.

18.   Ubah A record DNS milik abbey.xxx.com ke alamat IP yang fiktif (ubah secara random namun pastikan format IP valid). Naikkan nilai serial SOA di prab dan pastikan tedd ikut tersinkron. Tetapkan TTL sebesar 15 detik pada record yang relevan tersebut. Verifikasi momen yang terjadi pada tiga fase pencarian: sebelum perubahan terjadi (mengembalikan IP lama), saat perubahan baru saja terjadi dalam jeda 15 detik (masih IP lama karena cache), dan setelah batas waktu TTL habis (berubah ke IP fiktif yang baru). 

Record yang relevan adalah `abbey` (A) dan `static` (CNAME ke abbey), jadi keduanya kita beri TTL 15 detik. Alamat IP fiktif yang dipilih adalah `10.79.8.8`, karena formatnya valid dan tidak dipakai node mana pun di lab.

TTL adalah lama waktu sebuah jawaban boleh disimpan oleh cache. Server otoritatif seperti prab dan tedd tidak punya cache, sehingga selalu langsung menjawab data terbaru setelah zona di-reload. Agar efek TTL terlihat, query harus lewat resolver yang menyimpan cache. Karena itu kita pasang `unbound` pada prab di port 5353 (supaya tidak bentrok dengan `named` di port 53), yang meneruskan query zona `K31.com` ke prab.

```sh
#!/bin/bash
apt update
apt install unbound -y

mkdir -p /etc/unbound/unbound.conf.d

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

forward-zone:
    name: "K31.com"
    forward-addr: 10.79.1.2
EOF
```

Selanjutnya seluruh langkah pembuktian dikemas dalam satu script `soal-18.sh` pada prab.

```sh
#!/bin/bash
# bash soal-18.sh [IP-fiktif]  -> 3 fase (default 10.79.8.8)
# bash soal-18.sh balik        -> kembalikan IP lama
ZONE=/etc/bind/zones/K31.com
OLDIP=10.79.2.2
TEDD=10.79.1.3
ARG="${1:-10.79.8.8}"

pgrep unbound >/dev/null || unbound
sleep 1

ubah() {
  cp $ZONE /root/K31.com.bak
  sed -i -E "s/^abbey[[:space:]].*/abbey   15  IN  A   $1/" $ZONE
  sed -i -E "s/^static[[:space:]].*/static  15  IN  CNAME abbey.K31.com./" $ZONE
  OLD=$(grep -m1 "serial" $ZONE | grep -oE '[0-9]{10}')
  NEW=$((OLD+1))
  sed -i "s/$OLD/$NEW/" $ZONE
  echo "abbey -> $1 | serial: $OLD -> $NEW"
  named-checkzone K31.com $ZONE >/dev/null || { echo "Zona error"; cp /root/K31.com.bak $ZONE; exit 1; }
  rndc reload >/dev/null 2>&1 || { pkill named; sleep 1; named; }
  for i in $(seq 1 10); do
    [ "$(dig +short SOA k31.com @$TEDD | awk '{print $3}')" = "$NEW" ] && { echo "tedd sinkron (serial $NEW)"; return; }
    sleep 1
  done
  echo "PERINGATAN: tedd belum sinkron"
}

cek() {
  date
  echo "-- resolver cache:"
  dig +noall +answer -p 5353 abbey.k31.com @127.0.0.1
  echo "-- serial prab: $(dig +short SOA k31.com @127.0.0.1 | awk '{print $3}')  tedd: $(dig +short SOA k31.com @$TEDD | awk '{print $3}')"
}

if [ "$ARG" = "balik" ]; then ubah $OLDIP; cek; exit 0; fi

NEWIP="$ARG"
[[ $NEWIP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || { echo "Format IP salah"; exit 1; }
for o in ${NEWIP//./ }; do [ "$o" -le 255 ] || { echo "Oktet > 255"; exit 1; }; done

echo "# PERSIAPAN  #"
ubah $OLDIP
sleep 16
unbound-control flush_zone K31.com >/dev/null 2>&1

echo; echo "# FASE 1: sebelum perubahan (cache terisi IP lama) #"
cek

echo; echo "# UBAH ke $NEWIP #"
ubah $NEWIP

echo; echo "# FASE 2: Perubahan baru terjadi dalam jeda 15 detik (cache MASIH IP lama) #"
sleep 5
cek

echo; echo "##### FASE 3: setelah 15 detik habis (cache kedaluwarsa, IP baru) #####"
sleep 16
cek
```

Alur script ini dimulai dari persiapan, yaitu abbey dipastikan berada pada IP lama `10.79.2.2` dengan TTL 15, lalu script menunggu 16 detik supaya cache lama habis. Pada fase 1, query ke resolver mengisi cache dengan IP lama. Setelah itu A record abbey diganti menjadi `10.79.8.8`, serial dinaikkan, zona di-reload, dan script menunggu tedd sinkron. Pada fase 2, query dilakukan beberapa detik setelah perubahan (masih dalam 15 detik), sehingga resolver masih menjawab dari cache. Terakhir pada fase 3, script menunggu 16 detik sampai cache kedaluwarsa, lalu resolver menjawab dengan IP baru.

```sh
bash soal-18.sh | tee soal-18.txt
```

![alt text](assets/soal-18.png)

Dari hasil tersebut terbukti bahwa pada fase 2 resolver masih menjawab IP lama meskipun zona sudah berubah, karena jawaban itu masih tersimpan di cache selama TTL. Setelah 15 detik cache kedaluwarsa dan jawabannya berubah menjadi IP baru. Serial SOA pada prab dan tedd juga selalu sama, yang membuktikan sinkronisasi zona berjalan dengan baik.

Setelah verifikasi selesai, IP abbey dikembalikan seperti semula.

```sh
bash soal-18.sh balik
```

1.   Last? But not least? Buat CNAME record yang melakukan binding dari domain internal outbound.xxx.com menuju domain eksternal http.badssl.com, Lakukan perintah curl ke http://outbound.xxx.com dan pastikan output yang dihasilkan sesuai dengan isi konten di halaman http.badssl.com.

CNAME merupakan alias, yaitu nama yang menunjuk ke nama lain (bukan ke IP). Pada soal ini `outbound.k31.com` dibuat sebagai alias dari `http.badssl.com`, sehingga ketika `outbound.k31.com` di-resolve, DNS akan mengikuti alias tersebut sampai mendapatkan IP milik `http.badssl.com`.

Record ditambahkan pada zone file di prab (master), dengan titik di akhir nama tujuan karena merupakan nama lengkap (FQDN). Seperti soal-soal sebelumnya, serial SOA dinaikkan agar tedd menyalin zona terbaru, dan script menunggu sampai tedd sinkron sebelum menampilkan hasil query.

```sh
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
```

![alt text](assets/soal-19-1.png)

Dari gambar tersebut terlihat prab dan tedd sama-sama menjawab `outbound.K31.com` sebagai CNAME ke `http.badssl.com.` beserta IP hasil resolve-nya. Prab bisa me-resolve domain eksternal karena `named.conf.options` memiliki `forwarders { 192.168.122.1; }` dan `recursion yes`.

Selanjutnya pengujian dilakukan dari node alpha. Pertama kita lihat hasil resolve DNS-nya, lalu halaman yang diterima ketika mengakses `outbound.k31.com` dibandingkan dengan halaman `http.badssl.com`.

```sh
nslookup outbound.k31.com
curl -s http://outbound.k31.com
curl -s http://http.badssl.com
```

![alt text](assets/soal-19-2.png)

![alt text](assets/soal-19-3.png)

Dari gambar tersebut `nslookup` menampilkan `outbound.K31.com canonical name = http.badssl.com.`, sehingga CNAME terbukti bekerja. Nama `outbound.k31.com` berhasil di-resolve mengikuti alias menuju `http.badssl.com`, dan IP yang dikembalikan sama dengan IP milik `http.badssl.com`. Dari sini terbukti bahwa binding CNAME dari domain internal `outbound.k31.com` ke domain eksternal `http.badssl.com` berfungsi dengan baik.

20. Setelah semua penyelesaian selesai, pastikan semua service dan konfigurasi yang telah dikerjakan dari awal tetap berjalan normal dan berstatus autostart saat node di-restart (khusus untuk kasus ini, abaikan konfigurasi nomor 18 dan biarkan koordinat kembali normal).