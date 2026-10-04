# Jarkom-Modul-2-2026-K-31

| Nama | NRP | Soal |
|------|-----|------|
| Silfi Rochmatul Auliyah | 5027251008 | 11-20
| Nabila Sharliz Sigit | 5027251054 | 1-10

## Reporting

**1. Sebagai pusat kesadaran The Mesh, rootkit harus merentangkan koneksinya ke lima gerbang utama (Switch). Tetapkan alamat IP dan default gateway untuk seluruh Entitas,mulai dari para operator (alpha, beta, gamma), penjaga directory (prab, tedd), gerbang penyaring (abbey, penny), hingga repository (obladi, desmond, oblada, molly) sesuai dengan topologi pembagian switch yang dirancang. [GUNAKAN PREFIX IP MASING-MASING KELOMPOK].**

Topologi dengan rootkit sebagai router lalu 5 gerbang utama (Switch 1, Switch 4, Switch 5, Switch 6, dan Switch 7) serta gerbang dibawah Switch 1 yang memisahkan Penjaga Directory (prab, tedd) dan Reposiritory (obladi, desmond, oblada, molly). Pada Switch 6 ada Operator (alpha, beta, gamma), Switch 4 gerbang penyaring abbey, Switch 5 gerbang penyaring penny, dan Switch 7 untuk delta dan opsilon.

![alt text](topologi.png)

**2. Meskipun The Mesh beroperasi dalam bayang-bayang, Rootkit menyadari bahwa Entitas di dalamnya masih membutuhkan asupan paket dari dunia luar. Buka jalur menuju NAT dengan memastikan antarmuka WAN di router rootkit aktif. Konfigurasikan NAT agar dapat meneruskan lalu lintas keluar bagi seluruh alamat internal, sehingga semua host di dalam jaringan dapat menjangkau internet publik menggunakan IP address.**

Konfigurasi untuk router (rootkit): 

```sh
auto eth0                   // NAT
iface eth0 inet dhcp
    up sysctl -w net.ipv4.ip_forward=1
    up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

auto eth1                  // Switch 1
iface eth1 inet static
    address 10.79.1.1
    netmask 255.255.255.0

auto eth2                  // Switch 4
iface eth2 inet static
    address 10.79.2.1
    netmask 255.255.255.0

auto eth3                  // Switch 5
iface eth3 inet static
    address 10.79.3.1
    netmask 255.255.255.0

auto eth4                  // Switch 6
iface eth4 inet static
    address 10.79.4.1
    netmask 255.255.255.0

auto eth5                  // Switch 7
iface eth5 inet static
    address 10.79.5.1
    netmask 255.255.255.0

```

Konfigurasi untuk node prab:

```sh
auto eth0
iface eth0 inet static
    address 10.79.1.2
    netmask 255.255.255.0
    gateway 10.79.1.1
```

Konfigurasi untuk node tedd:

```sh
auto eth0
iface eth0 inet static
    address 10.79.1.3
    netmask 255.255.255.0
    gateway 10.79.1.1
```

Konfigurasi untuk node obladi:

```sh
auto eth0
iface eth0 inet static
    address 10.79.1.4
    netmask 255.255.255.0
    gateway 10.79.1.1
```

Konfigurasi untuk node desmond:

```sh
auto eth0
iface eth0 inet static
    address 10.79.1.5
    netmask 255.255.255.0
    gateway 10.79.1.1
```

Konfigurasi untuk node oblada:

```sh
auto eth0
iface eth0 inet static
    address 10.79.1.6
    netmask 255.255.255.0
    gateway 10.79.1.1
```

Konfigurasi untuk node molly:

```sh
auto eth0
iface eth0 inet static
    address 10.79.1.7
    netmask 255.255.255.0
    gateway 10.79.1.1
```

Konfigurasi untuk node abbey:

```sh
auto eth0
iface eth0 inet static
    address 10.79.2.2
    netmask 255.255.255.0
    gateway 10.79.2.1
```

Konfigurasi untuk node penny:

```sh
auto eth0
iface eth0 inet static
    address 10.79.3.2
    netmask 255.255.255.0
    gateway 10.79.3.1
```

Konfigurasi untuk node alpha:

```sh
auto eth0
iface eth0 inet static
    address 10.79.4.2
    netmask 255.255.255.0
    gateway 10.79.4.1
```

Konfigurasi untuk node beta:

```sh
auto eth0
iface eth0 inet static
    address 10.79.4.3
    netmask 255.255.255.0
    gateway 10.79.4.1
```

Konfigurasi untuk node gamma:

```sh
auto eth0
iface eth0 inet static
    address 10.79.4.4
    netmask 255.255.255.0
    gateway 10.79.4.1
```

Konfigurasi untuk node delta:

```sh
auto eth0
iface eth0 inet static
    address 10.79.5.2
    netmask 255.255.255.0
    gateway 10.79.5.1
```

Konfigurasi untuk node epsilon:

```sh
auto eth0
iface eth0 inet static
    address 10.79.5.3
    netmask 255.255.255.0
    gateway 10.79.5.1
```

**3. Jaringan rahasia tidak akan berfungsi tanpa sinkronisasi antar divisi. Pastikan seluruh Entitas dapat saling terhubung dan berkomunikasi lintas jalur (routing internal via rootkit berfungsi). Untuk menghindari fragmentasi saat persiapan, pastikan setiap host non-router menambahkan resolver 192.168.122.1 (tambah di file /etc/resolv.conf, kalau sudah pakai resolver itu tidak perlu memasukkan resolver google) saat antarmukanya aktif agar akses untuk mengunduh paket instalasi dari internet tersedia sejak awal beroperasi.**

Menambahkan DNS resolver pada seluruh node:

```sh
nano /etc/resolv.conf
nameserver 192.168.122.1
```

**4. Penjaga Direktori mulai menuliskan hukum The Mesh. Pada node prab, bangun zona <xxxx>.com sebagai authoritative dengan SOA yang menunjuk ke prab .< xxxx>.com, serta tambahkan catatan NS untuk prab .< xxxx>.com dan tedd .< xxxx>.com. Buat A record untuk prab .< xxxx>.com dan tedd .< xxxx>.com yang mengarah ke alamat IP mereka masing-masing, serta A record apex <xxxx>.com yang mengarah ke gerbang aplikasi dinamis (penny). Aktifkan fitur notify dan allow-transfer ke tedd, lalu set forwarders ke 192.168.122.1. Di node tedd, tarik zona <xxxx>.com dari master dan pastikan server menjawab secara authoritative. Setelah fondasi nama ini berdiri kokoh, perbarui urutan resolver pada seluruh Entitas non-router menjadi: IP prab, IP tedd, lalu 192 168.122.1. Verifikasi bahwa query ke domain apex maupun hostname di dalam zona dijawab dengan benar oleh prab atau tedd.**

Pertama-tama pada node prab, jalankan script install-bind9.sh dan juga script setup-dns-prab.sh, yang kurang lebih isinya adalah sebagai berikut:

```sh
apt install bind9 bind9-utils bind9-dnsutils -y
service named started

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
```
Setelah meng-install bind-9, membuat directory /etc/bind/zones lalu mengisi pengaturan pada /etc/bind/named.conf.options, lalu mendaftarkan zona dan menentukan peran pada /etc/bind/named.conf.local, dimana pada zone K31.com perannya adalah master dengan also-notify node tedd. Pada etc/bind/zones/K31.com atau file zona untuk mengisi data, seperti nameserver (NS), address (A), dan juga start of authority (SOA) dari prab dan tedd.

Kedua pada node tedd, jalankan script yang sama namun untuk setup menggunakan script setup-dns-tedd.sh yang isinya kurang lebih sebagai berikut:

```sh
apt install bind9 bind9-utils bind9-dnsutils -y
service named restart

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
```

Yang dimana pada node tedd sendiri hanya mengisi local dan juga options, perbedaannya pada local perannya adalah slave dengan master nya yaitu prab.

Pengecekan:

![alt text](assets/soal_4(1).png)
![alt text](assets/soal_4(2).png)

Set all non-router host /etc/resolv.conf menjadi berikut:

```sh
nameserver 10.79.1.2
nameserver 10.79.1.3
nameserver 192.168.122.1
```


**5. Entitas tanpa identitas adalah anomali," pesan Rootkit. Namai semua Entitas (hostname) sesuai glosarium: rootkit, alpha, beta, gamma, delta, epsilon, prab, tedd, abbey, penny, obladi, desmond, oblada, molly, dan verifikasi bahwa setiap host mengenali hostname tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai dengan namanya (contoh: alpha .< xxxx>.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas prab dan tedd.**

Set hostname pada seluruh node, contoh pada node prab:

```sh
cat >> nano/etc/hostname << 'EOF'
prab
EOF
```
Setelah itu, untuk dapat mengenalu hostname secara system-wide tambahkan ini juga pada seluruh node:

```sh
cat >> nano/etc/hosts << 'EOF'
10.79.4.2       alpha
10.79.4.3       beta
10.79.4.4       gamma
10.79.5.2       delta
10.79.5.3       epsilon
10.79.1.2       prab
10.79.1.3       tedd
10.79.2.2       abbey
10.79.3.2       penny
10.79.1.4       obladi
10.79.1.5       desmond
10.79.1.6       oblada
10.79.1.7       molly
EOF
```

Pada node prab, tambah ini untuk mendaftarkan semua host ke DNS

```sh
cat >> nano /etc/bind/zones/K31.com << 'EOF'
alpha   IN      A       10.79.4.2
beta    IN      A       10.79.4.3
gamma   IN      A       10.79.4.4
delta   IN      A       10.79.5.2
epsilon IN      A       10.79.5.3
abbey   IN      A       10.79.2.2
penny   IN      A       10.79.3.2
obladi  IN      A       10.79.1.4
desmond IN      A       10.79.1.5
oblada  IN      A       10.79.1.6
molly   IN      A       10.79.1.7
EOF
```
Pengecekan:

![alt text](assets/soal_5.png)


**6. Pastikan zone transfer berjalan, pastikan tedd telah menerima salinan zona terbaru dari prab. Nilai serial SOA di keduanya harus sama karena keduanya tidak bisa dipisahkan dan saling melengkapi.**

Untuk mengecek apakah serial SOA prab dan tedd sama, lakukan menggunakan dig yaitu sebagai berikut:

![alt text](assets/soal_6.png)

**7. abbey dan penny sebagai gerbang utama, obladi dan desmond sebagai web statis, oblada dan molly sebagai web dinamis. Tambahkan pada zona <xxxx>.com A record untuk vault .< xxxx>.com (IP obladi & desmond), dan core .< xxxx>.com (IP oblada & molly). Tetapkan CNAME:
. www .< xxxx>.com -> penny .< xxxx>.com
. static .< xxxx>.com -> abbey .< xxxx>.com 
Verifikasi dari dua klien berbeda bahwa seluruh hostname t ersebut ter-resolve ke tujuan yang benar dan konsisten.**

Pada DNS master (node prab), tambahkan code berikut pada /etc/bind/zones/K31.com, untuk mendaftarkan IP obladi & desmond sebagai vault, IP oblada & molly sebagai core, CNAME www untuk penny dan CNAME static untuk abbey

```sh
vault   IN      A       10.79.1.4
vault   IN      A       10.79.1.5
core    IN      A       10.79.1.6
core    IN      A       10.79.1.7
www     IN      CNAME   penny.K31.com
static  IN      CNAME   abbey.K31.com
```

Verifikasi menggunakan dig: 

Verifikasi menggunakan lynx:

**8. Di prab (master) deklarasikan reverse zone untuk segmen jaringan tempat abbey, penny, area vault, dan area core berada. Di tedd (slave) tarik reverse zone tersebut sebagai slave, isi PTR untuk keempat hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat abbey, penny, area vault, dan area core dijawab authoritative.**

Pada node prab lakukan reverse zone pada area vault dan area core dengan membedakan subnet nya, tambah pada /etc/bind/named.conf.local

```sh
cat >> /etc/bind/named.conf.local << 'EOF'

zone "K31.com" {
    type master;
    file "/etc/bind/zones/K31.com";
    notify yes;
    also-notify { 10.79.1.3; };
    allow-transfer { 10.79.1.3; };
};

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


nano /etc/bind/zones/x.79.10.in-addr.arpa
Buat yg zone .1 (vault dan core)
$TTL    604800 
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026093001 604800 86400 2419200 604800 )
@       IN      NS      prab.K31.com
@       IN      NS      tedd.K31.com
4       IN      PTR     vault.K31.com
5       IN      PTR     vault.K31.com
6       IN      PTR     core.K31.com
7       IN      PTR     core.K31.com

Zone .2 (abbey)
$TTL    604800 
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026093001 604800 86400 2419200 604800 )
@       IN      NS      prab.K31.com
@       IN      NS      tedd.K31.com
2      IN      PTR     abbey.K31.com

Zone .3 (penny)
$TTL    604800 
@       IN      SOA     prab.K31.com. root.K31.com. (
                        2026093001 604800 86400 2419200 604800 )
@       IN      NS      prab.K31.com
@       IN      NS      tedd.K31.com
2      IN      PTR     penny.K31.com
EOF
```

Pada node tedd, tarik reverse zone sebagai slave

```sh
cat >> /etc/bind/named.conf.local << 'EOF'
zone "1.79.10.in-addr.arpa" {
    type slave;
    master { 10.79.1.2; };
    file "/etc/bind/zones/1.79.10.in-addr.arpa";
};

zone "2.79.10.in-addr.arpa" {
    type slave;
    master { 10.79.1.2; };
    file "/etc/bind/zones/2.79.10.in-addr.arpa";
};

zone "3.79.10.in-addr.arpa" {
    type slave;
    master { 10.79.1.2; };
    file "/etc/bind/zones/3.79.10.in-addr.arpa";
};
EOF
```



**9.Jalankan layanan web statis pada hostname di node area vault (menggunakan apache). Buka folder direktori /arsip/ dan aktifkan fitur autoindex (directory listing) pada konfigurasi Apache sehingga seluruh daftar file di dalamnya dapat ditelusuri langsung dari browser. Akses pengujian harus dilakukan melalui hostname, bukan IP address.**

Install apache pada node vault (obladi & desmond), buat directory untuk arsip lalu beri contoh dengan mengisikan 3 file berbeda dengan ketentuan 755 ()

```sh
apt-get update && apt-get install -y apache2 
mkdir -p /arsip
touch /arsip/file1.txt /arsip/file2.txt /arsip/file3.txt
chmod -R 755 /arsip
```

Set vault configuration:

```sh
cat >> /etc/apache2/sites-available/vault.conf << 'EOF'
<VirtualHost *:80>
    ServerName vault.K31.com
    DocumentRoot /var/www/html

    Alias /arsip /arsip

    <Directory /arsip>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
EOF
```

```sh
echo "ServerName vault.K31.com" > /etc/apache2/conf-available/servername.conf
a2enconf servername
service apache2 start
service apache2 status
a2enmod autoindex
a2dissite 000-default.conf
a2ensite vault.conf
service apache2 restart
```

**10.Jalankan layanan web dinamis (PHP-FPM) pada hostname di node core (menggunakan nginx). Buat sebuah aplikasi sederhana yang memuat halaman beranda dan halaman profil. Terapkan aturan rewrite pada server sehingga akses ke /profil dapat berfungsi dengan URL bersih (tanpa akhiran .php). Akses pengujian wajib dilakukan melalui hostname.**

Pada node core (oblada & molly) download nginx dan lakukan setup sebagai berikut:

```sh
apt-get update && apt-get install -y nginx php-fpm
service php8.4-fpm start
service php8.4-fpm status
ls /run/php
mkdir -p /var/www/core
```

Isi index.php dengan berikut:

```sh
cat >> nano /var/www/core/index.php << 'EOF'
<?php
echo "<h1>Beranda</h1>";
echo "<p>Selamat datang di " . gethostname() . "</p>";
echo "<a href='/profil'>Lihat Profil</a>";
EOF
```
Isi profil.php dengan berikut:

```sh
cat >> nano /var/www/core/profil.php << 'EOF'
<?php
echo "<h1>Profil</h1>";
echo "<p>Ini halaman profil dari " . gethostname() . "</p>";
echo "<a href='/'>Kembali ke Beranda</a>";
EOF
```

```sh
chown -R www-data:www-data /var/www/core
chmod -R 755 /var/www/core
ln -s /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
service nginx restart
```

**11. Konfigurasikan Penny (menggunakan Apache) sebagai reverse proxy yang mengarah ke semua node di area vault (Obladi & Desmond). Sementara itu, konfigurasikan Abbey (menggunakan Nginx) sebagai reverse proxy menuju area core (Oblada & Molly). Pastikan kedua gerbang ini meneruskan identitas asli pengunjung ke server backend dengan melakukan forwarding header Host dan X-Real-IP. Buktikan bahwa Penny dan Abbey berhasil mendistribusikan lalu lintas dengan tepat.**

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
for i in 1 2 3 4 5 6; do lynx -dump -nolist http://10.79.3.2/ done
for i in 1 2 3 4 5 6; do lynx -dump -nolist http://static.k31.com/; done
```
 
![alt text](assets/soal-11-curl-penny.png)

![alt text](assets/soal-11-curl-abbey.png)

Hasil lynx bergantian antara kedua node dengan perbandingan 3:3, yang membuktikan traffic terdistribusi secara seimbang.
 
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

**12. Terdapat ruang khusus di penny yang yang menyimpan dokumen rahasia sindikat, oleh karena itu terapkan perlindungan basic authentication untuk path /admin. Akses ke jalur tersebut harus menolak pengunjung tanpa kredensial, dan hanya mengizinkan masuk jika menggunakan credential berikut:**
    
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
lynx -dump -nolist http://10.79.3.2/admin/
lynx -dump -nolist http://prabs:salah@10.79.3.2/admin/
lynx -dump -nolist http://prabs:pakar_pinter_jadi_gob***@10.79.3.2/admin/
```

![alt text](assets/soal-12-tes-1.png)

![alt text](assets/soal-12-tes-2.png)

![alt text](assets/soal-12-tes-3.png)

Tanpa kredensial dan dengan password salah, server membalas `401 Unauthorized` dengan header `WWW-Authenticate: Basic realm="Admin Area"`. Dengan kredensial yang benar, server membalas `200 OK` dengan isi halaman admin. Path `/` tetap meneruskan request secara bergantian ke obladi dan desmond, sehingga reverse proxy tidak terganggu.
 
Pada saat pengujian sempat muncul `Password Mismatch` pada `error.log` karena password yang dikirim berbeda dengan yang di-hash pada `.htpasswd`. Masalah ini diselesaikan dengan mengatur ulang password menggunakan `htpasswd -b` (tanpa `-c` agar file tidak tertimpa).

**13. Setiap entitas dari luar harus memanggil gerbang dengan nama kanoniknya. Jika ada yang mencoba mengakses IP penny dan domain  penny.k31.com, paksa sistem untuk melakukan redirect secara permanen (status code 301) menuju www.k31.com. Sebaliknya, jika ada yang mengakses IP abbey dan domain abbey.k31.com, lakukan redirect sementara (status code 302) menuju static.k31.com.**

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
lynx -source -head http://10.79.3.2/
lynx -head http://penny.k31.com/
lynx -head http://www.k31.com/
```

![alt text](assets/soal-13-penny-1.png)

![alt text](assets/soal-13-penny-2.png)

![alt text](assets/soal-13-penny-3.png)

```sh
lynx -head http://10.79.2.2/
lynx -head http://abbey.k31.com/
lynx -head http://static.k31.com/
```

![alt text](assets/soal-13-abbey-1.png)

![alt text](assets/soal-13-abbey-2.png)

![alt text](assets/soal-13-abbey-3.png)

Dari gambar tersebut terlihat bahwa akses lewat IP penny dan `penny.k31.com` dibalas `301 Moved Permanently` dengan `Location: http://www.k31.com/`. Sedangkan akses lewat IP abbey dan `abbey.k31.com` dibalas `302 Moved Temporarily` dengan `Location: http://static.k31.com/`. Akses lewat nama kanonik (`www.k31.com` dan `static.k31.com`) tetap dilayani dan meneruskan request ke backend secara bergantian.

**14. Di dalam The Mesh, rekam jejak tidak boleh dipalsukan oleh sistem. Pastikan access log pada setiap server web di area vault maupun area core mencatat alamat IP asli milik client (pengunjung) yang diteruskan oleh gerbang, dan bukan mencatat IP dari Penny ataupun Abbey.**

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
for i in 1 2 3 4 5 6; do lynx -dump -nolist http://www.k31.com/; done
```

![alt text](assets/soal-14-curl-penny.png)

```sh
for i in 1 2 3 4 5 6; do lynx -dump -nolist http://static.k31.com/; done
```

![alt text](assets/soal-14-curl-abbey.png)

Kemudian, kita bisa melihat `access.log` pada setiap backend.
```sh
tail -n 3 /var/log/apache2/access.log   
tail -n 3 /var/log/nginx/access.log     
```

![alt text](assets/soal-14-accesslog-vault.png)

![alt text](assets/soal-14-accesslog-core.png)

Dari gambar tersebut terlihat kolom pertama pada log berisi `10.79.4.2` (IP alpha), bukan `10.79.3.2` (penny) atau `10.79.2.2` (abbey), sehingga terbukti backend mencatat IP client asli.

**15.  Rootkit menginstruksikan pembuatan jalur proxy khusus yang berdiri sendiri. Pada penny buat reverse proxy untuk path /eternal yang menyajikan directory /var/www/eternal, dan pastikan path ini dapat mengeksekusi (rendering) file php. Pada abbey, buat jalur /orion yang menyajikan directory /var/www/orion, secara murni statis tanpa perlu rendering php.**

Untuk penny, sama seperti `/admin`, path `/eternal` harus dilayani penny sendiri dan tidak diteruskan ke backend. Karena Apache di penny memakai `mpm_event`, PHP dijalankan lewat PHP-FPM dengan modul `proxy_fcgi`, bukan `mod_php`. Pertama-tama kita install PHP-FPM dan menyalakannya.
 
```sh
apt update
apt install php-fpm -y
a2enmod proxy_fcgi
 
PHPV=$(ls /etc/php | sort -V | tail -n 1)
mkdir -p /run/php
service php${PHPV}-fpm start || php-fpm${PHPV} -D
ls /run/php/
```
 
Pastikan file socket `php8.4-fpm.sock` (sesuai versi yang terdeteksi) muncul. Setelah itu kita buat direktori dan file uji PHP.
 
```sh
mkdir -p /var/www/eternal
cat > /var/www/eternal/index.php << 'EOF'
<?php
echo "eternal jalan, PHP " . phpversion();
EOF
chown -R www-data:www-data /var/www/eternal
```
 
Selanjutnya blok berikut ditambahkan pada virtual host penny, di bawah blok `/admin` dan sebelum `ProxyPass /`.
 
```apache
    ProxyPass /eternal !
    Alias /eternal /var/www/eternal
 
    <Directory /var/www/eternal>
        Require all granted
        DirectoryIndex index.php index.html
        <FilesMatch "\.php$">
            SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost"
        </FilesMatch>
    </Directory>
```
 
Baris `SetHandler "proxy:unix:...|fcgi://localhost"` meneruskan file berekstensi `.php` ke PHP-FPM untuk dieksekusi. Setelah itu Apache direstart penuh.
 
```sh
apache2ctl configtest
pkill apache2; sleep 2; apache2ctl start
```
 
Saat pengujian sempat muncul `404 Not Found`. Setelah dicek dengan `grep -n "eternal" /etc/apache2/sites-enabled/*.conf`, ternyata blok `/eternal` belum masuk ke file konfigurasi yang aktif, sehingga request jatuh ke `ProxyPass /` dan ditangani oleh backend. Konfigurasi kemudian ditulis ulang secara utuh dan Apache direstart.
 
Untuk abbey, path `/orion` dibuat murni statis. Nginx tidak punya PHP bawaan, tetapi supaya file `.php` tidak terbuka sebagai teks (source code bocor), ekstensi `.php` di path ini kita tolak dengan 403. Pertama kita siapkan folder dan file ujinya.
 
```sh
mkdir -p /var/www/orion
echo "orion statis" > /var/www/orion/index.html
cat > /var/www/orion/tes.php << 'EOF'
<?php echo "php jalan"; ?>
EOF
chmod -R a+rX /var/www/orion
```
 
Lalu blok berikut ditambahkan pada server `static.k31.com`, sebelum `location /`.
 
```nginx
    location = /orion {
        return 301 /orion/;
    }
 
    location ^~ /orion/ {
        root /var/www;
        index index.html;
    }
```
 
```sh
nginx -t && nginx -s reload
```
 
Pengujian dilakukan melalui alpha pada kedua gerbang.
 
```sh
lynx -dump -nolist http://10.79.3.2/eternal/index.php

lynx -dump -nolist http://10.79.2.2/orion/tes.php
```

![alt text](assets/soal-15-eternal.png)

![alt text](assets/soal-15-orion.png)
 
Dari gambar tersebut terbukti bahwa `/eternal/index.php` menampilkan hasil eksekusi PHP (bukan kode `<?php` mentah), dan `/orion/` menampilkan `orion statis` dengan header `Server: nginx`. Sementara itu `/orion/tes.php` dibalas `403 Forbidden`, sehingga PHP tidak dieksekusi maupun dibuka. Path `/` pada kedua gerbang tetap diteruskan ke backend.

**16. Ketahanan gerbang The Mesh harus diuji untuk menghadapi bombardir permintaan. Salah satu Klien (misal: Alpha) bertugas melakukan stress test benchmark menggunakan ApacheBench. Lakukan 250 requests dengan tingkat konkurensi (concurrencies) 10 untuk masing - masing titik akhir: www.xxx.com dan static.xxx.com. Tampilkan rangkuman hasilnya.**

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

**17. Tambahkan TXT record pada DNS untuk semua klien sayap kiri dan sayap kanan (Alpha, Beta, Gamma, Delta, Epsilon). Jika DNS di-query TXT terhadap nama domain mereka (contoh: alpha.k31.com), sistem harus mengembalikan teks berupa nama hostname mereka masing-masing (contoh: "alpha").**

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

**18. Ubah A record DNS milik abbey.xxx.com ke alamat IP yang fiktif (ubah secara random namun pastikan format IP valid). Naikkan nilai serial SOA di prab dan pastikan tedd ikut tersinkron. Tetapkan TTL sebesar 15 detik pada record yang relevan tersebut. Verifikasi momen yang terjadi pada tiga fase pencarian: sebelum perubahan terjadi (mengembalikan IP lama), saat perubahan baru saja terjadi dalam jeda 15 detik (masih IP lama karena cache), dan setelah batas waktu TTL habis (berubah ke IP fiktif yang baru).**

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

**19. Last? But not least? Buat CNAME record yang melakukan binding dari domain internal outbound.xxx.com menuju domain eksternal http.badssl.com, Lakukan perintah curl ke http://outbound.xxx.com dan pastikan output yang dihasilkan sesuai dengan isi konten di halaman http.badssl.com.**

Pada soal ini `outbound.k31.com` dibuat sebagai alias dari `http.badssl.com`, sehingga ketika `outbound.k31.com` di-resolve, DNS akan mengikuti alias tersebut sampai mendapatkan IP milik `http.badssl.com`.

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

**20. Setelah semua penyelesaian selesai, pastikan semua service dan konfigurasi yang telah dikerjakan dari awal tetap berjalan normal dan berstatus autostart saat node di-restart (khusus untuk kasus ini, abaikan konfigurasi nomor 18 dan biarkan koordinat kembali normal).**

Node pada GNS3 berupa container tanpa systemd, sehingga service seperti Apache, Nginx, PHP-FPM, dan BIND tidak otomatis menyala ketika node dinyalakan ulang. Agar service tetap hidup setelah restart, kita memanfaatkan cara yang sama seperti pada modul 1, yaitu menaruh perintah `up` pada `/etc/network/interfaces`. Perintah tersebut dijalankan setiap kali interface `eth0` aktif, termasuk saat node baru dinyalakan.

Pertama-tama konfigurasi soal 18 diabaikan, jadi kondisinya dikembalikan ke normal terlebih dahulu. Abbey dikembalikan ke `10.79.2.2`, TTL 15 pada record `abbey` dan `static` dihapus, dan unbound dimatikan. Langkah ini dilakukan di prab.

```sh
bash /root/soal-18.sh balik
pkill unbound
sed -i -E 's/^abbey[[:space:]]+15[[:space:]]+/abbey   /; s/^static[[:space:]]+15[[:space:]]+/static  /' /etc/bind/zones/K31.com
OLD=$(grep -m1 "serial" /etc/bind/zones/K31.com | grep -oE '[0-9]{10}')
sed -i "s/$OLD/$((OLD+1))/" /etc/bind/zones/K31.com
named-checkzone K31.com /etc/bind/zones/K31.com && rndc reload
dig +noall +answer abbey.k31.com @10.79.1.2
dig +short SOA k31.com @10.79.1.3
```

Dari hasil tersebut `abbey` kembali ke `10.79.2.2` tanpa TTL 15, dan serial pada prab dan tedd sama.

Selanjutnya pada setiap node dibuat script `/root/autostart.sh`. Script ini dibuat ringan, jadi tidak menjalankan ulang script per nomor yang sudah dibuat sebelumnya. Script hanya melakukan tiga hal secara berurutan. Pertama, `setup-klien.sh` dijalankan agar `resolv.conf` dan `/etc/hosts` kembali ke pengaturan lab. Kedua, service yang dibutuhkan node tersebut diinstall hanya jika belum ada. Ketiga, service dinyalakan jika belum berjalan. Proses berjalan di latar belakang setelah jeda 5 detik supaya tidak menahan `ifup`, dan hasilnya dicatat di `/root/autostart.log`. Isi `ROLE` disesuaikan dengan node, yaitu `penny`, `abbey`, `vault` (obladi dan desmond), `core` (oblada dan molly), `prab`, atau `tedd`.

```sh
#!/bin/bash
ROLE="penny"   # penny | abbey | vault | core | prab | tedd

(
  sleep 5

  # 1. DNS dan /etc/hosts sesuai lab
  [ -f /root/setup-klien.sh ] && bash /root/setup-klien.sh

  # 2. install service kalau belum ada
  need() { # perintah, paket...
    CMD=$1; shift
    command -v $CMD >/dev/null 2>&1 && return
    echo "$CMD belum ada, install: $@"
    echo "nameserver 192.168.122.1" > /etc/resolv.conf
    apt-get update
    apt-get install -y "$@"
    [ -f /root/setup-klien.sh ] && bash /root/setup-klien.sh
  }

  case $ROLE in
    penny) need apache2ctl apache2 apache2-utils
           need php-fpm8.4 php-fpm ;;
    abbey) need nginx nginx ;;
    vault) need apache2ctl apache2 ;;
    core)  need nginx nginx
           need php-fpm8.4 php-fpm ;;
    prab|tedd) need named bind9 bind9-utils bind9-dnsutils ;;
  esac

  # 3. nyalakan service
  PHPV=$(ls /etc/php 2>/dev/null | sort -V | tail -n 1)
  case $ROLE in
    penny) mkdir -p /run/php
           pgrep -f "php-fpm: master" >/dev/null || php-fpm${PHPV} -D
           pgrep apache2 >/dev/null || apache2ctl start ;;
    abbey) pgrep nginx >/dev/null || nginx ;;
    vault) pgrep apache2 >/dev/null || apache2ctl start ;;
    core)  mkdir -p /run/php
           pgrep -f "php-fpm: master" >/dev/null || php-fpm${PHPV} -D
           pgrep nginx >/dev/null || nginx ;;
    prab|tedd) pgrep named >/dev/null || named ;;
  esac
) > /root/autostart.sh 2>&1 &
```

Script yang sama dipakai pada kedelapan node (penny, abbey, obladi, desmond, oblada, molly, prab, dan tedd), hanya nilai `ROLE` yang diganti. Setelah itu script dipasang pada `/etc/network/interfaces` sebagai perintah `up` di bawah `iface eth0`. Pengecekan `grep` memastikan baris tidak ditambahkan dua kali.

![alt text](assets/soal-20.png)

Dari gambar tersebut terlihat baris `up ./autostart.sh` berada di bawah `iface eth0`, sehingga script dijalankan setiap kali interface aktif.