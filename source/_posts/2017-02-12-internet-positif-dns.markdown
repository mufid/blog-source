---
layout: post
title: "Internet Positif, DNSCrypt, dan Internet yang Terkesan Melambat"
date: 2017-02-12 15:30
comments: true
lang: id
---

Masih ingat kasus pemblokiran Twitter di Turki? 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Twitter is blocked in Turkey. On the streets of Istanbul, the action against censorship is graffiti DNS addresses. <a href="http://t.co/XcsfN7lJvS">pic.twitter.com/XcsfN7lJvS</a></p>&mdash; Utku Can (@utku) <a href="https://twitter.com/utku/status/446956710502993920">March 21, 2014</a></blockquote>

<!-- more -->

Semua orang menyarankan untuk menggunakan Google DNS. Akan tetapi, di
Indonesia, Google DNS di-redirect oleh pemerintah kita lewat program bernama
internet positif. Mari kita buktikan:

	$ dig reddit.com @8.8.8.8
	
	; <<>> DiG 9.11.0-P3 <<>> reddit.com @8.8.8.8
	;; global options: +cmd
	;; Got answer:
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 2443
	;; flags: qr rd; QUERY: 1, ANSWER: 2, AUTHORITY: 1, ADDITIONAL: 0
	;; WARNING: recursion requested but not available
	
	;; QUESTION SECTION:
	;reddit.com.                    IN      A
	
	;; ANSWER SECTION:
	reddit.com.             604800  IN      CNAME   internet-positif.org.
	internet-positif.org.   30      IN      A       118.97.116.27
	
	;; AUTHORITY SECTION:
	telkomblacklisting.co.id. 604800 IN     SOA     localhost. root.localhost. 2017021207 3600 3600 604800 604800
	
	;; Query time: 2 msec
	;; SERVER: 8.8.8.8#53(8.8.8.8)
	;; WHEN: Sun Feb 12 07:43:20 SE Asia Standard Time 2017
	;; MSG SIZE  rcvd: 152

Anda bisa lihat pada baris `ANSWER`, saya mendapatkan balasan 
`internet-positif.org.` untuk pertanyaan `reddit.com.`. Aneh sekali, bukan?
Padahal saya sudah meminta agar DNS Google (8.8.8.8) yang menjawab. Saya
menduga, sebuah *firewall* atau semacamnya me-*redirect* *traffic* dari port
DNS (53).
Alih-alih tersambung ke DNS Google, paket saya di re-route ke DNS pemerintah.

Oleh karenanya, saya menggunakan [DNSCrypt](https://dnscrypt.org/).

Dalam banyak kasus, saya selalu menggunakan DNSCrypt. Alasan pertama adalah
alasan kecepatan respons perintah DNS. Dalam beberapa kasus, 
DNS "pemerintah" terlalu lambat dan
peramban saya menjadi tidak bekerja. Alasan kedua adalah ada beberapa situs
yang justru tidak bisa diakses dengan DNS "pemerintah" pada beberapa kasus.
Misalnya saja [CloudApp](https://my.cl.ly).

Berhubung DNSCrypt bukanlah protokol DNS biasa, Anda perlu menggunakan perantara
agar Anda dapat mulai menggunakan DNSCrypt. Perantara ini akan bertindak sebagai
DNS Server biasa. Anda kemudian akan menyambungkan ke DNS Server ini. Di
Windows, Anda dapat menggunakan perantara bernama
[SimpleDNSCrypt](https://simplednscrypt.org/).

Ketika DNSCrypt telah terpasang, dia akan hidup, *by default*, di *loopback*
127.0.0.1 pada port 53. Mari kita coba bertanya alamat IP dari Reddit.com
lewat DNSCrypt:

	$ dig reddit.com @127.0.0.1
	
	; <<>> DiG 9.11.0-P3 <<>> reddit.com @127.0.0.1
	;; global options: +cmd
	;; Got answer:
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50641
	;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 4, ADDITIONAL: 2
	
	;; OPT PSEUDOSECTION:
	; EDNS: version: 0, flags:; udp: 4096
	;; QUESTION SECTION:
	;reddit.com.                    IN      A
	
	;; ANSWER SECTION:
	ReDdit.COM.             262     IN      A       151.101.65.140
	ReDdit.COM.             262     IN      A       151.101.193.140
	ReDdit.COM.             262     IN      A       151.101.1.140
	ReDdit.COM.             262     IN      A       151.101.129.140
	
	;; AUTHORITY SECTION:
	ReDdit.COM.             67583   IN      NS      ns-378.awsdns-47.com.
	ReDdit.COM.             67583   IN      NS      ns-1029.awsdns-00.org.
	ReDdit.COM.             67583   IN      NS      ns-1887.awsdns-43.co.uk.
	ReDdit.COM.             67583   IN      NS      ns-557.awsdns-05.net.
	
	;; ADDITIONAL SECTION:
	ns-378.awsdns-47.COM.   172526  IN      A       205.251.193.122
	
	;; Query time: 392 msec
	;; SERVER: 127.0.0.1#53(127.0.0.1)
	;; WHEN: Sun Feb 12 07:43:40 SE Asia Standard Time 2017
	;; MSG SIZE  rcvd: 283
	
Baiklah. Sekarang saya bisa mengakses Reddit. Akan tetapi, masalah belum
selesai. Beberapa web memang responnya lebih cepat (hostname query), tetapi
kecepatan transfer menjadi lebih lambat. Hal ini CDN, ya, Content Delivery
Network yang justru dirancang agar Anda dapat menikmati konten lebih cepat
justru melambat dengan Anda menggunakan DNSCrypt. Ini karena beberapa CDN
menggunakan DNS untuk mendeteksi mana server yang "terdekat" dengan kita.

Contohnya adalah Origin. Saat saya mengunduh dari Origin, internet terasa lambat
sekali. Saya menggunakan langganan 10 mbps, tetapi kecepatan yang saya dapat
justru hanya sekitar sepersepuluhnya:

![](/images/post/origin-slow.png)

Kalau saya matikan DNSCrypt, inilah yang terjadi:

![](/images/post/origin-fast.png)

Mengapa seperti itu? Saat tidak menggunakan DNSCrypt, proses pencarian server
terdekat oleh CDN terjadi secara "natural" karena memang kita menggunakan DNS
yang terdekat dengan kita, dalam kasus ini adalah DNS Telkom. Akan tetapi,
ketika menggunakan DNSCrypt, CDN akan "dibodohi" karena mereka tidak tahu
bahwa DNS yang kita gunakan bukanlah DNS yang terdekat dengan kita. Dalam
konteks saya, saya menggunakan server DNSCrypt di Eropa.

Mari kita buktikan. Saya akan menggunakan [Process Explorer] dari Sysinternals.
Saya pilih Origin, klik kanan > Properties. Kemudian, saya pilih TCP/IP.

Saat tersambung tanpa DNSCrypt, Origin tersambung ke jaringan berikut:

	a104-93-98-193.deploy.static.akamaitechnologies.com
	36.66.10.126
	a104-93-87-243.deploy.static.akamaitechnologies.com

Mari kita ambil yang paling atas karena host tersebut memiliki sambungan
paling banyak di komputer saya saat pengujian dilakukan. Lakukan `traceroute`
ke host tersebut:

	$ tracert a104-93-98-193.deploy.static.akamaitechnologies.com
	
	Tracing route to a104-93-98-193.deploy.static.akamaitechnologies.com [104.93.98.193]
	over a maximum of 30 hops:
	
	  1    <1 ms    <1 ms    <1 ms  1.1.168.192.in-addr.arpa [192.168.1.1]
	  2     4 ms     1 ms     1 ms  36.77.192.1
	  3     1 ms     1 ms     1 ms  PE-BOO-HUAWEI.telkom.net.id [125.160.0.113]
	  4     1 ms     1 ms     1 ms  69.171.94.61.in-addr.arpa [61.94.171.69]
	  5     2 ms     7 ms     6 ms  a104-93-98-193.deploy.static.akamaitechnologies.com [104.93.98.193]
	
	Trace complete.

Sekarang, keluar dari Origin, sambungkan DNSCrypt, dan lihat sambungan yang
terjadi. Ternyata banyak sambungan ke
`a92-122-201-149.deploy.akamaitechnologies.com`. Jika kita traceroute:

	$ tracert a92-122-201-149.deploy.akamaitechnologies.com
	
	Tracing route to a92-122-201-149.deploy.akamaitechnologies.com [92.122.201.149]
	over a maximum of 30 hops:
	
	  1    <1 ms    <1 ms    <1 ms  192.168.1.1
	  2     5 ms     3 ms     3 ms  36.77.192.1
	  3     4 ms     1 ms     1 ms  125.160.0.113
	  4     1 ms     1 ms     1 ms  61.94.171.69
	  5    20 ms    23 ms    22 ms  180.240.191.42
	  6    17 ms    16 ms    16 ms  180.240.191.41
	  7   155 ms   154 ms   156 ms  180.240.196.33
	  8   167 ms   165 ms   165 ms  akamai.par.franceix.net [37.49.236.168]
	  9   164 ms   164 ms   164 ms  a92-122-201-149.deploy.akamaitechnologies.com [92.122.201.149]
	
	Trace complete.

Anda dapat lihat di sana, kita mengakses server CDN yang di Eropa. Cukup
jelas mengapa kecepatan pengunduhan menjadi melambat.

**UPDATE:** Ternyata, ini tergantung dari server DNSCrypt yang dipilih. 
Tadinya saya hanya memilih Cisco OpenDNS. Pada
saat post ini ditulis, saya tidak sadar ada server yang dekat, di Singapura.
Saat ini saya selalu menggunakan DNSCrypt dan memilih server Singapura. Dengan
demikian, tidak ada dampak negatif yang terasa. Ping tetap terasa tinggi
dan kecepatan transfer tetap tinggi.

**Update 2:** Dokumen ini ditulis pada Februari 2017, tetapi saat saya coba lagi
di Agustus 2017, kecepatan unduh Origin tidak selambat sebelumnya. Memang masih
tetap lebih lambat daripada menggunakan CDN yang dekat, tetapi saat ini sudah
jauh lebih baik. Saya mendapatkan kecepatan sekitar 800 kbps, alih-alih di bawah
500 kbps beberapa bulan yang lalu. Sepertinya Telkom telah berbaik hati untuk
melepas throttle ke server yang jauh dari Indonesia. Yay!

[Process Explorer]: https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer