---
layout: post
title: Memindahkan Data Wordpress Pada Apache dan Ubuntu 16.04
date: 2019-11-27 15:34
comments: true
categories:
lang: id
---

Cara-cara:

- Siapkan mesin baru
- Backup data dari mesin lama
- Restore data ke mesin baru
- Done

<!-- more -->

## Menyiapkan Mesin Baru

Sebelum memulai, pastikan DNS sudah propagate ke mesin baru.

Spin up mesin baru kemudian perbaru dulu

    # apt-get update
    # apt-get upgrade

Lakukan instalasi Apache dan Mariadb

    # apt-get install apache2 mariadb

Konfigurasikan Mariadb ke default yang aman:

    # mysql_secure_installation

Lakukan instalasi Certbot

    $ sudo apt-get update
    $ sudo apt-get install software-properties-common
    $ sudo add-apt-repository universe
    $ sudo add-apt-repository ppa:certbot/certbot
    $ sudo apt-get update
    $ sudo apt-get install certbot python-certbot-apache 

Instalasi apache2 SSL dari Certbot:

    $ sudo certbot --apache

Virtual Host biasanya akan kosong. Tidak masalah, nanti pilih saja yang di le-ssl.

Lakukan instalasi PHP 7.0:

    # apt-get install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-mbstring php7.0-gd php7.0-xml php7.0-xmlrpc php7.0-intl php7.0-soap php7.0-zip

## Backup dari mesin lama

Backup HTML:

    $ cd /var/www
    $ tar cvf www-backup.tar.gz www

Kirim ke mesin baru:

    $ scp www-backup.tar.gz root@mesinbaru:~

Backup SQL

    $ mysqldump -u [user] -p [database_name] > mysqlbackup.sql

Kirim ke mesin baru:

    $ scp mysqlbackup.sql root@mesinbaru:~

## Restore Mesin Baru

Extract dan salin arsip HTML:

    $ tar xvf www-backup.tar.gz
    $ cp html /var/www -r
    $ cd /var/www
    $ chown www-data:www-data www -r

Buat akun Mariadb:

    $ mariadb
    mariadb> CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'passwordyangdiinginkan';
    mariadb> GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';
    mariadb> FLUSH PRIVILEGES;

Buat database wordpress-nya:

    $ mariadb
    mariadb> CREATE DATABASE databasenya;

Restore database:

    $ mysql -u newuser -p databasenya < mysqlbackup.sql

Selesai. Bagian akhir dari dokumen.
