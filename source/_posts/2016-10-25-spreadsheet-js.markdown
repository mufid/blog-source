---
layout: post
title: "Lembar Kerja dalam Tiga Puluh Baris Javascript"
date: 2016-10-25 08:00
comments: true
lang: id
---

![Spreadsheet](/images/post/spreadsheet-js.gif)

Saya menjelajahi kembali beberapa tautan yang ada di penanda saya. Saya menemukan
tautan yang sangat menarik beberapa tahun lampau: membuat lembar kerja dalam 30
baris di Javascript. Woh!

Baiklah, untuk membuat cerita lebih pendek, saya melihat kembali dimana keajaiban
baris kode tersebut. Anda dapat melihat kode sumber aslinya di [Codepen](http://jsfiddle.net/ondras/hYfN3/)
(via [HN](https://news.ycombinator.com/item?id=6725387)). Pertanyaan saya ada
dua:

- Bagaimana menyelesaikan formula di sana?
- Bagaimana *dependency resolution* antar sel di lembar kerja tersebut?

Mari kita bahas yang pertama. Ini menjadi hal yang menarik bagi saya karena
penyelesaian formula berarti Anda membuat DSL sendiri, menerjemahkannya, dan
mengeksekusinya. DSL yang digunakan oleh semua program lembar kerja serupa.
DSL yang digunakan juga dekat dengan bahasa pemrograman pada umumnya. Ya,
menguraikan formula menjadi hal yang dimengerti dan dieksekusi oleh mesin
bukanlah hal yang sederhana.

Ternyata, program Javascript ini tidak memiliki DSL sendiri. Alih-alih,
program ini menggunakan perintah `eval` sederhana untuk menguraikan
dan mengeksekusi formulanya. Yup, tentu saja jika Anda memasukkan
perintah Javascript yang aneh-aneh --- bukan bentuk formula lembar
kerja pada umumnya --- Anda akan menemukan sedikit kejanggalan. Anda
dapat memberikan perintah `alert` pada perintahnya dan `alert` akan
bena-benar muncul. Tentu saja bukan suatu hal yang akan Anda lakukan
pada mesin produksi, tetapi ini sudah sangat baik sebagai sebuah PoC.

Mari kita bahas yang kedua: bagaimana *dependency resolution* dilakukan?
Anggap saya memiliki sel A1 berisi `=B2 * 5` dan B2 yang berisi `=100*C2`
dan C2 yang berisi `99`? Bagaimana penyelesaian keterkaitan formula
yang berbeda sel? Ah, "keajaiban" bahasa yang interpret di sini.

Anda dapat melihat di kode tersebut: ada perintah yang membuat property.
Lihat pada bagian ini:

    var getter = function() {
        var value = localStorage[elm.id] || "";
        if (value.charAt(0) == "=") {
            with (DATA) return eval(value.substring(1));
        } else { return isNaN(parseFloat(value)) ? value : parseFloat(value); }
    };
    Object.defineProperty(DATA, elm.id, {get:getter});
    Object.defineProperty(DATA, elm.id.toLowerCase(), {get:getter});

Ini adalah dokumentasi dari [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty):

> Object.defineProperty(obj, prop, descriptor)
>
> Parameters
> 
> - obj  
>   The object on which to define the property.
> - prop  
>   The name of the property to be defined or modified.
> - descriptor  
>   The descriptor for the property being defined or modified.

Jadi, pada dasarnya, `eval` akan dilakukan dengan property di dalam
object bernama `DATA`. Property-nya sendiri bersifat dinamis, di dalam
fungsi. Properti baru benar-benar didapatkan nilainya apa ketika dieksekusi.
Jadi, sebenarnya yang melakukan dependency resolution adalah `eval` itu sendiri.
Program ini tidak benar-benar membuat *dependency graph* seperti yang
saya bayangkan sebelumnya.


