---
layout: post
title: "Tentang Web"
date: 2013-01-25 15:00
comments: true
categories:
lang: id
---

<!-- more -->

Beberapa hal yang sering ditanyakan tentang web ke saya:

#### Apa yang Paling Penting dalam Web?

Entah. Saya juga kurang tahu. Mungkin, konten?. Tidak sedikit web dengan desain yang biasa saja tetapi dengan konten yang menarik. Katakanlah web [Raspberry] yang sederhana tapi isinya selalu mutakhir.

#### Referensi Web Keren?

[CSSDA], [Awwwards], [Behance]

#### Bikin Web itu Pakai Apa?

Halaman web ditaruh di sebuah server (atau ada yang menyebut hosting). Halaman web itu ada pemrosesnya agar teks yang hanya berisi record entri database yang tidak semua orang mengerti menjadi sebuah tampilan yang indah. Pemroses ini dinamakan Content Management System (CMS). Dengan CMS, semua orang dapat hidup lebih menyenangkan: unggah program CMS ke server, install di server, dan server Anda menampilkan tampilan seperti blog atau berita.

Ada banyak CMS di dunia ini. [Wordpress](http://wordpress.org) yang paling banyak digunakan. Meski ada [Joomla](http://joomla.org), [Fork](http://forkcms.com/), [Drupal](http://drupal.org/). Kalau Anda merasa gak sreg dengan CMS yang ada, Anda dapat [meminta programmer membuatkan CMS untuk Anda].

Beberapa web dibuat dengan static page. Tidak dibuat dengan CMS, tapi murni dibuat "dengan tangan" bukan "dengan mesin komputer". Web static page cocok untuk web yang kontennya tidak banyak berubah, seperti misalnya web [pergerakan](http://www.browserawarenessday.com) atau [infografis](http://mailchimp.com/2012/).

#### Saya ingin buat dengan subdomain .ui.ac.id, semisal komunitasganteng.ui.ac.id

Jika pertanyaan ini diajukan oleh mahasiswa UI, sila kontak PPSI-UI terkait hal ini.

#### Berapa biaya bikin web?

Yang sudah pasti adalah nyewa server atau sering disebut "hosting". Selain menyewa server, Anda harus menyewa nama untuk alamat web Anda, atau sering disebut sewa "domain". Anda search di Google atau Kaskus, maka Anda akan melihat banyak perusahaan yang menawarkan jasa ini.

Untuk kebutuhan standar, paket hosting adalah 10 ribu rupiah per bulan. Harga domain rata-rata tidak jauh berbeda, berkisar antara 70 ribu rupiah hingga 100 ribu rupiah per tahun.

#### SEO itu Apa?

Search Engine semacam Google bukan hanya mendata konten dari suatu halaman web, tetapi juga mendata metadata web itu seperti deskripsi, judul, bahasa, kata kunci utama (seperti dalam jurnal atau skripsi). Search Engine Optimation adalah teknik agar metadata dan konten di web kita berada di peringkat teratas Google saat dicari.

#### Berapa harga template?

Kalau Anda main-main ke <themeforest.net>, Anda akan melihat harga satu buah template berkisar antara 40 hingga 50 dolar AS. Dengan membeli template yang keren, Anda membuat tampilan web Anda indah dalam waktu singkat dan tanpa perlu usaha.

Meski, banyak template yang gratis yang bisa Anda cari seperti di situs resmi masing-masing CMS.

#### Hosting Rekomendasi?

Cari saja yang paling murah, dan customer servicenya sigap membalas pesan Anda. Tidak ingin kan saat web down kemudian customer service tidak dapat dihubungi?

#### Paket Apa yang Sebaiknya Saya Pakai?

Dalam banyak kasus, space 100 MB saja sudah kebanyakan dan hampir jarang penuh. Sebagai gambaran, jika Anda menggunakkan wordpress, maka wordpress itu sendiri hanya mengabiskan 12 MB di server Anda. Jika Anda mengunggah gambar, gambar akan diresize oleh wordpress dan paling hanya membutuhkan 200 KB per gambar. Artinya, Anda masih dapat menyimpan 500++ gambar di server dengan space 100 MB

Anda pasti akan mempertimbangkan hosting dengan kapasitas yang lebih besar jika Anda sering menambah konten di web.

#### Saya mau dibuatkan web custom, seperti Facebook tapi bisa ini bisa itu. Berapa biayanya?

Tergantung sekali. Beberapa web developer lain mematok harga berdasarkan jam kerja mereka. Beberapa pekerjaan voluntir dibayar gratis.

Anda lebih baik pergi ke digital agency untuk bertanya tentang ini. Sila email mereka. Tenang saja, mereka semua orang-orang baik kok.

#### Bandwidth itu apa?

Besar pita. Artinya berapa banyak data yang masuk dan data yang keluar dalam jangka waktu tertentu. Untuk hosting di luar Indonesia biasanya harus bayar traffic tambahan jika *jumlah pengakses* web kita sudah melebihi batas yang ditetapkan.

#### IIX itu Apa?

Indonesia Internet Exchange. Artinya server ada di wilayah Indonesia. Biasanya lebih cepat, traffic/bandwidth gratis, tetapi entah kenapa lebih mahal.

#### Jika Dikerjakan secara profesional, bagaimana workflow dari pembuatan web?

Sebaiknya Anda mengambil kuliah [rekayasa perangkat lunak](http://en.wikipedia.org/wiki/Software_engineering). Tentu awalnya agensi web akan bertanya kepada Anda tentang tujuan web ini dibuat, pesan yang ingin disampaikan, dan cara penyampainnya. Agensi kemudian akan menentukan web apa yang cocok, CMSnya apa, hostingnya sebaiknya seperti apa, dan lainnya.

Dalam bekerja, pada umumnya akan ditemui dua tipe pekerja teknis: desainer dan developer. Desainer mengatur tampilan dari web dan developer akan menyulap tampilan itu menjadi kode-kode yang berjalan di server.

Web yang lebih kompleks yang melibatkan banyak sistem akan melibatkan beberapa ahli seperti system analyst. Ini di luar bahasan kita saat ini. Anda tidak sedang ingin membangun startup, kan?

#### Cloud itu Apa? PaaS itu apa?

It so hard to explain! Anggap sebuah apartemen yang di kamar-kamar. Apartemen itu ibarat penyedia layanan hosting dan kamar itu hostingnya. Ada salah satu kamar atau lebih yang itu milik Anda karena Anda telah menyewanya.

Cloud adalah apartemen yang tidak memiliki kamar. Penyewa bebas menggunakkan ruangan yang tersedia, mau kecil mau besar. Itulah sebabnya cloud sering digunakan untuk skala besar, karena perawatannya yang mudah (kalau "tamu" alias pengunjung webnya sedang banyak, sewa ruangan yang besar. Jika tidak, sewa yang kecil saja). Pengubahan ukuran ruangan bisa dilakukan suka-suka penyewa, kapan saja.

Mengapa ini bisa terjadi? Thanks to virtualization. Konsep ini sudah lama, hanya saja sekarang lebih hype.

PaaS adalah menyewa apartemen yang sudah tersedia berbagai perkakas untuk bekerja di dalamnya (Platform-as-a-service).

[meminta programmer membuatkan CMS untuk Anda]: /blog/2012/should-i-hire-a-programmer/
[CSSDA]: http://cssdesignawards.com
[Awwwards]: http://awwwards.com
[Behance]: http://behance.net
[Raspberry]: http://raspberrypi.org
[Full Stack Programmer]: http://www.feld.com/wp/archives/tag/full-stack-programmer
[kursus desain]: http://hackdesign.org
