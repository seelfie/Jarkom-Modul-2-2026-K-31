# Jarkom-Modul-2-2026-K-31

| Nama | NRP | Soal |
|------|-----|------|
| Silfi Rochmatul Auliyah | 5027251008 | 1-10
| Nabila Sharliz Sigit | 5027251054 | 11-20

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