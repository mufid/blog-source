---
layout: post
title: "DNS Speedy Lambat"
date: 2014-09-20 07:54
comments: true
categories:
lang: id
---

Jadi, saya menghidupkan VPN di San Fransisco.
Kalau saya sambungkan komputer saya ke VPN saya;
ajaib, saya browsing apapun terasa cepat sekali.
Akan tetapi, saya tidak merasa ada penurunan
kecepatan internet. Saya curiga ada masalah di DNS.
Oleh karena itu, mari kita cari tahu.

<!-- more -->

Pertama, VPN saya *by default* menggunakan Google
DNS. Saya pastikan bahwa saya tidak bohong dan
tidak dibohongi:

{% codeblock mark:14 %}
    vagrant@classifier:/vagrant$ dig -x 8.8.8.8

    ; <<>> DiG 9.8.1-P1 <<>> -x 8.8.8.8
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 64887
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;8.8.8.8.in-addr.arpa.          IN      PTR

    ;; ANSWER SECTION:
    8.8.8.8.in-addr.arpa.   86361   IN      PTR     google-public-dns-a.google.com.

    ;; Query time: 85 msec
    ;; SERVER: 10.0.2.3#53(10.0.2.3)
    ;; WHEN: Sat Sep 20 00:51:33 2014
    ;; MSG SIZE  rcvd: 82
{% endcodeblock %}

*(Ah iya, maaf, saya sedang login di Vagrant, jadi saya pakai Vagrant)*

Tidak ada masalah. Saya benar tersambung dengan Google DNS (lihat
rekaman PTR. Perhatikan Query Time nya juga di 4 baris dari terakhir).

Sekarang, mari kita bermain dengan Speedy DNS aka. Telkom DNS:

{% codeblock mark:19 %}
    vagrant@classifier:/vagrant$ dig -x 118.98.44.10

    ; <<>> DiG 9.8.1-P1 <<>> -x 118.98.44.10
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 57154
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;10.44.98.118.in-addr.arpa.     IN      PTR

    ;; ANSWER SECTION:
    10.44.98.118.in-addr.arpa. 86400 IN     PTR     10.subnet118-98-44.astinet.telkom.net.id.

    ;; AUTHORITY SECTION:
    44.98.118.in-addr.arpa. 86400   IN      NS      dns1.telkom.net.id.
    44.98.118.in-addr.arpa. 86400   IN      NS      dns2.telkom.net.id.

    ;; Query time: 1057 msec
    ;; SERVER: 10.0.2.3#53(10.0.2.3)
    ;; WHEN: Sat Sep 20 00:51:42 2014
    ;; MSG SIZE  rcvd: 135
{% endcodeblock %}

> WAT? 1057 msec? APA APAAN NIH? Gimana ceritanya saya bisa query DNS
> ke US lebih cepat daripada query DNS ke negara sendiri!

Karena saya penasaran, saya coba ping keduanya:

{% codeblock mark:1,12 %}
    vagrant@classifier:/vagrant$ ping 8.8.8.8
    PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
    64 bytes from 8.8.8.8: icmp_req=1 ttl=48 time=304 ms
    64 bytes from 8.8.8.8: icmp_req=2 ttl=48 time=241 ms
    64 bytes from 8.8.8.8: icmp_req=3 ttl=48 time=241 ms
    64 bytes from 8.8.8.8: icmp_req=4 ttl=48 time=240 ms
    ?
    --- 8.8.8.8 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3006ms
    rtt min/avg/max/mdev = 240.019/256.838/304.573/27.565 ms

    vagrant@classifier:/vagrant$ ping 118.98.44.10
    PING 118.98.44.10 (118.98.44.10) 56(84) bytes of data.
    64 bytes from 118.98.44.10: icmp_req=13 ttl=252 time=24.9 ms
    64 bytes from 118.98.44.10: icmp_req=14 ttl=252 time=25.5 ms
    64 bytes from 118.98.44.10: icmp_req=15 ttl=252 time=25.3 ms
    64 bytes from 118.98.44.10: icmp_req=17 ttl=252 time=23.8 ms
    64 bytes from 118.98.44.10: icmp_req=26 ttl=252 time=168 ms
    64 bytes from 118.98.44.10: icmp_req=27 ttl=252 time=24.3 ms
    64 bytes from 118.98.44.10: icmp_req=30 ttl=252 time=90.9 ms
    64 bytes from 118.98.44.10: icmp_req=31 ttl=252 time=212 ms
    ?
    --- 118.98.44.10 ping statistics ---
    31 packets transmitted, 8 received, 74% packet loss, time 30232ms
    rtt min/avg/max/mdev = 23.830/74.471/212.579/71.128 ms
{% endcodeblock %}

Nah ini. Kenapa query DNS ke negara sendiri bisa lebih lambat
daripada ke negara orang? Note: Saya gak percaya, jangan-jangan
saya masih tersambung ke VPN saya. Sayang sekali, saya tidak
bisa melakukan traceroute dari sini.

Tetapi jika Anda mengalami masalah yang sama, boleh coba
Anda cek, Anda konek ke VPN Anda, kemudian ping ke 8.8.8.8.
Catat hasilnya, putuskan sambungan ke VPN Anda, kemudian
ping ke 118.98.44.10 dan apakah hasilnya sama? Mungkin
dari situ kita bisa saling periksa hasilnya.
