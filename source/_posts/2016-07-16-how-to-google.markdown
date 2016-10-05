---
layout: post
title: "Cara Googling"
date: 2016-07-16 22:25
comments: true
categories:
lang: id
---

Beberapa orang mengeluhkan kepada saya karena gagal menemukan masalah
pemrograman apa yang ingin dicari di Google. Berikut adalah panduan singkat
berdasarkan keluhan-keluhan yang coba saya pahami.

<!-- more -->

## Mengetahui Etika dan Cara Bertanya yang Baik

Pastikan Anda telah mengetahui etika bertanya. Jika Anda belum membacanya,
bacalah. Baca versi terjemahan dari "How to Ask Question The Smart Way"
oleh Harry Sufehmi di sini: <http://harry.sufehmi.com/archives/2012-11-07-2556/>

## Menanyakan Hal yang Tepat

Selanjutnya, Google bukanlah mesin ajaib yang bisa membaca pikiran kita.
Google hanya dapat menampilkan informasi dari apa yang telah diindeks olehnya.
Oleh karena itu, pikirkan kira-kira kata kunci apa yang perlu dimasukkan di
Google dan ada di dalam indeks Google.

Kita ambil contoh untuk galat. "repair" adalah kata valid untuk memperbaiki.
"Fix" pun kata yang valid untuk memperbaiki. Dua-duanya bisa dipakai. Akan
tetapi, ketika digabungkan dengan "bug", maka ternyata Google memiliki
informasi "fix bug" lebih banyak daripada "repair bug". Oleh karena itu,
sebaiknya Anda menggunakan kata-kata "fix" dibanding "repair".

![Fix, Jangan Repair](/images/post/trends-bug-repair.png)

Beberapa orang tidak merekomendasikan pencarian yang mengandung kata kurang
bermakna seperti "How to X" dan "What is Y". Ini ada benarnya karena kata-kata
yang tidak bermakna justru akan mengotori hasil pencarian. Contohnya Anda
sedang ingin mencari nama komputer yang dibuat oleh Apple, maka dimanakah
kira-kira Anda dapat melihat nama komputernya? Tentu di websitenya Apple. Meski
demikian, memasukkan "apple computer apple website" menghasilkan

## Mengetahui Konteks

Anda perlu mengetahui konteks terhadap apa yang ingin Anda cari. Sebagai contoh,
Anda ingin mengetahui konsep "bridge" di dunia pemrograman. Anda perlu secara
sadar memahami bahwa Anda sedang mencari konsep bridge, bukan jembatan fisik,
atau apapun itu.

Memasukkan "bridge programming" mungkin akan menemukan hal yang tidak
bermakna. Ada banyak hal yang berkaitan dengan bridge. Jangan-jangan, kita
malah menemukan bagaimana caranya membuat permainan kartu. Ya, penting
bagi kita untuk mengetahui konteks bahwa ada permainan kartu bernama bridge.

Maka dari itu, kita perlu memahami konteksnya. "Bridge seperti apa yang kita
cari?" Kita perlu menilik bridge ini dekat ke apa. Apakah library? Bukan.
Ini adalah konsep pemrograman. Maka kita perlu menilik lagi, "Apa saja
konteks yang ada di konsep pemrograman?"

Secara umum, kita bisa membuka buku pemrograman dasar seperti Big Java atau
buku-buku di seri Heads Up dan melihat "bridge" ini lebih dekat ke mana.

- "Data Structure". Apakah bridge ini termasuk ke struktur data? Semacam
  LinkedList? Sepertinya relevansinya kurang. Lanjut ke bab selanjutnya.
- "User Interface". Tentu saja bukan gambar jembatan yang kita maksud
- "Network". Baiklah, kita mulai menemukan masalah. Kalau Anda mencari "bridge
  network" maka Anda akan menemukan banyak sekali hasil yang terkesan relevan.
  Di sinilah penting untuk memahami konteks: Hasilnya terkesan relevan, tapi
  apakah ini yang Anda cari? Ketika menelusuri lebih dalam, ternyata ada istilah
  "bridge" juga di pemrograman jaringan, tetapi bukan konsep pemrograman itu
  yang sedang kita cari.
- "Algorithm". Oke, ini kasusnya mirip dengan butir sebelumnya. Terkesan
  menjadi solusi padahal bukan ini yang kita cari.
- "Design Pattern". Aha. Ketika kita mencari "bridge design pattern", maka
  kita akan menemukan hal yang tepat!

Pemahaman konteks juga penting agar kita menggunakan terminologi yang tepat.
Di dunia terkait, banyak istilah yang sama tapi artinya berbeda.
Semisal, "instance" itu bisa berarti
kelas yang sudah di-construct (kelas yang telah di-instatiate), atau
juga bisa berarti mesin-mesin VM yang hidup ("EC2 Instance" misalnya).

## Lebih Umum, atau Lebih Spesifik

Ketika mencari error, panduan umumnya adalah googling saja pesan errornya.
Atau, boleh jadi error itu intermitent (hanya kadang-kadang terjadi) sehingga
kita perlu mencari hal yang lebih umum dari error yang bersangkutan. Atau,
boleh jadi error tersebut sangat kontekstual sehingga kita perlu mencari
tingkatan yang lebih umum.

Misalnya, errornya terjadi karena NullPointerException. Ini sudah cukup jelas;
kesalahan terjadi karena Anda mencoba mengakses objek yang nilainya null. Akan
tetapi, Anda tidak sedang mem-pass parameter yang null. Oleh karena itu, coba
lihat lagi secara lebih umum. Meng-google "NullPointerException java" akan
menghasilkan hasil pencarian yang sampah. Hindari.

Akan tetapi, misalnya Anda ternyata menggunakan library Spring dengan modul
Autowired. Coba ini saja yang dicari, jadi "NullPointerException spring
autowired".

## Forum!

Ketika Anda telah melakukan itu semua, tetapi belum menemukan jawabannya,
selamat, masalah Anda ternyata tidak
ada di Google. Akan tetapi, Anda telah sangat mengerti permasalahan yang
Anda alami. Bertanyalah di forum atau StackOverflow. Atau, beberapa
komunitas juga memiliki Slack. Coba tanya di sana. Anda akan dibalas dengan
cepat. Percayalah, orang-orang di internet akan sangat menghargai Anda
jika Anda telah melakukan usaha memahami dulu apa yang hendak Anda tenyakan.