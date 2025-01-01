---
layout: post
title: Tes
date: 2025-01-01 19:02
comments: true
categories:
lang: id
---

Saya menggunakan Terraform Cloud. Saya tidak sadar ada perbaruan di
Terraform. Akan sangat baik jika saya bisa selalu ada di versi
paling tinggi untuk meminimalkan masalah. Akan tetapi, layaknya
langkah migrasi untuk perbaruan versi dari 0.11 ke 0.12, versi 0.13 ini
juga menawarkan langkah migrasi khusus. Saya menjalankan perintah
berikut di lokal kemudian langsung push ke Terraform Cloud via GitHub:

    terraform 0.13upgrade

Karena percaya diri tidak ada masalah, saya langsung menggunakan
versi 0.13 di Terraform Cloud. Sayang sekali, saya malah menemukan
masalah berikut:

![Tangkapan Layar Could Not Load Plugin](/images/post/terraform-could-not-load-plugin.png)

Wow... kenapa ya? Selidik punya selidik, saya menemui laman
GitHub berikut: [https://github.com/hashicorp/terraform/issues/26104](https://github.com/hashicorp/terraform/issues/26104).
Tampaknya saya harus menjalankan perintah replace-provider karena Terraform
menggunakan struktur URL yang berbeda untuk provider registry mereka.
Pada laman GitHub tersebut, ditampilkan bahwa dia perlu mengganti registry URL
untuk Vault. Oleh karena problem saya adalah di DigitalOcean, maka saya
mengganti provider untuk DigitalOcean:

    $ terraform state replace-provider -auto-approve registry.terraform.io/-/digitalocean registry.terraform.io/digitalocean/digitalocean

    Terraform will perform the following actions:

      ~ Updating provider:
        - registry.terraform.io/-/digitalocean
        + registry.terraform.io/digitalocean/digitalocean

    Changing 8 resources:

      ...<woops, rahasia he-he-he>

Selesai! Terraform Cloud sekarang berjalan seperti sebagaimana seharusnya.
