---
layout: post
title: "Memasang Discourse di Ubuntu Server 14.04"
date: 2014-06-25 18:52
comments: true
categories:
lang: id
---

Discourse sepertinya akan menjadi hype. Sudah
mulai banyak adopsi Discourse di beberapa forum.
Anda sendiri juga bisa melakukannya. Baiklah,
kalau begitu, mari kita coba memasang Discourse!

<!-- more -->

## In ASCIINema

<script type="text/javascript" src="https://asciinema.org/a/10462.js" id="asciicast-10462" async></script>

<https://asciinema.org/a/10462>

## Persiapan VirtualBox

Saya menggunakan VirtualBox 4 dengan port
forwarding (agar bisa langsung mengakses localhost).
Adapun konfigurasi port forwardingnya sebagai
berikut:

	coming soon...

## Menginstall Discourse

Well, H1 ini cuman iseng. Abaikan. Biar
SEOnya bagus, *gitu*.

Btw, semua instruksi di sini sudah saya uji coba
ulang dengan VirtualBox. Seharusnya, Anda bisa
mengikuti semua instruksi di sini tanpa
ada masalah.

## Bumbu Masak

[Sesuai saran dari tim Discourse sendiri](https://github.com/discourse/discourse/blob/master/docs/INSTALL.md),
instalasi sebaiknya menggunakan Docker. Hal ini
karena Discourse membutuhkan banyak sekali *dependency*.
*Dependency* ini akan cukup repot jika dipasang
secara terpisah. Oleh karena itu, gunakan saja
Docker.

Di sini, saya akan menguji coba instalasi dengan
Ubuntu Server 14.04. Anda bisa mendapatkan
*image* dari Ubuntu Server 14.04 dari [kambing.ui.ac.id](http://kambing.ui.ac.id/iso/ubuntu/releases/14.04/).
Jangan lupa, x64 (sesuai yang disarankan). Oh iya,
di dokumen resmi Docker, Ubuntu 14.04 tidak termasuk
dalam sistem operasi yang didukung. Tidak masalah,
kita coba saja, yay!

![Menyenangkan sekali download dari UI](/images/post/download-ubuntu.png)

Saya akan mencoba ini semua di VirtualBox. Lakukan
instalasi seperti biasa. Kita akan kembali setelah Anda
melakukan instalasi OSnya.

## Memulai Instalasi Docker

Anda sudah mengetahui bahwa Discourse merupakan
aplikasi Rails. Pada kenyataannya, Anda tidak
perlu install Rails. Anda juga tidak perlu install
Redis dan kawan-kawannya, meski ini dibutuhkan
oleh Discourse. Hal ini karena semua
instalasi akan diabstrasikan oleh Docker.
Kalau begitu, kita lanjutkan saja
dengan [menginstall Docker](http://docs.docker.com/installation/ubuntulinux/).

	sudo apt-get install curl
	curl -s https://get.docker.io/ubuntu/ | sudo sh

> Catatan: Instruksi di atas berlaku untuk
> Ubuntu 14.04, yang mana *kernel*nya sudah
> kompatibel dengan virtualisasi Docker

Okeh, sekarang Docker sudah dipasang. Anda bisa
pastikan dengan melihat versinya:

	docker --version

Setelah itu, buat sebuah folder discourse docker:

	install -g docker -m 2775 -d /var/docker

Tambahkan user Anda ke user Docker agar kita bisa
utak-atik. Dalam hal ini, nama user saya adalah maru:

	usermod -a -G docker maru # Sesuaikan

## Memasang `discourse_docker`

Sekarang, saatnya memasang docker dengan resep
Discourse.

1. Clone

		git clone https://github.com/discourse/discourse_docker.git /var/docker

1. Pergi ke repo docker_discourse

		cd /var/docker

1. Salin konfigurasi default

		cp samples/standalone.yml containers/app.yml

    Sebetulnya Anda bisa langsung lanjut ke langkah
	selanjutnya. Akan tetapi, mungkin Anda tertarik
	untuk melihat isi konfigurasi *expose* dari
	`app.yml` ini. Ubah semua isi `app.yml` yang
	jika dirasa dibutuhkan. Anda mungkin tertarik
	untuk melihat konfigurasi pada bagian `bindings`
	dan `volumes`.

1. Lakukan *boostrapping*. Tepat sekali, proses ini
   agak lama, jadi silahkan buat kopi dan nikmati
   sejenak. Atau, Anda dapat menyaksikan
   tayangan-tayangan yang [menggugah hati,
   menyayat pikiran, dan memberikan inspirasi](http://hummingbird.me/anime/clannad-after-story). Pengalaman
   Saya, ini membutuhkan waktu kurang lebih 60 menit.

		sudo ./launcher bootstrap app
		# Yeah, hanya satu baris, tapi lama, banget.

1. Fiyuh, setelah semua *dependency* diselesaikan,
   akhirnya kita bisa memulai *image*-nya:

		sudo ./launcher start app

Selesai! Mari kita lakukan web config

## Konfigurasi *on-site* Discourse

Cihuy, Discourse sudah bisa digunakan!
Sekarang, Anda tinggal mengikuti
instruksi di halaman webnya saja
dari browser.

![Welcome to Discourse](/images/post/discourse-welcome.png)