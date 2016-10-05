---
layout: post
title: "A simple pattern in Java: equals"
date: 2014-10-28 20:16
comments: true
categories:
lang: id
---

Di Java, kita menggunakan `.equals()` untuk membandingkan suatu *instance* apakah bernilai sama atau tidak. Yang masalah adalah ketika Anda membandingkan nilai null. Mari kita ambil contoh kasus sederhana: validasi apakah suatu email dari user berhak mendapatkan bingkisan spesial atau tidak dari nilai yang sudah ditentukan. Misalnya kodenya seperti ini:

    String email = request.getEmail();
    if (email.equals("yui.hirasawa@example.com")) {
      condition.fullfilled();
      return;
    }
    condition.fail();

Ada yang aneh dari kode di atas? Tidak ada. Kode di atas sempurna, sampai Anda menyadari bahwa **email bisa bernilai null**. Akhirnya, equals akan dipanggil ke null. Hal ini menyebabkan NullPointerException. Sehingga, Anda perlu menambahkan hal seperti ini:

    String email = request.getEmail();
    if (email == null) {
      condition.fail();
      return;
    }
    if (email.equals("yui.hirasawa@example.com")) {
      condition.fullfilled();
      return;
    }
    condition.fail();

Well... bisa sih, tapi sebetulnya agak melelahkan. Coba perhatikan bahwa predefined email sudah pasti ada, tetapi email input bisa saja null. Kita bisa mencegah exception karena NullPointerException tanpa menambah baris kode sama sekali:

    String email = request.getEmail();
    if ("yui.hirasawa@example.com".equals(email)) {
      condition.fullfilled();
      return;
    }
    condition.fail();

TL;DR: Di Java, jika Anda menggunakan equals, dan salah satu objek dari dua objek yang dibandingkan mungkin mengandung nilai null, maka **panggil `.equals()` dari objek yang sudah pasti bukan null**.

Happy Coding!