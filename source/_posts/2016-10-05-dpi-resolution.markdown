---
layout: post
title: "Resolusi Monitor dan DPI"
date: 2016-10-05 08:00
comments: true
lang: id
---

Saya sudah berencana sejak lama sekali untuk mengganti monitor saya dari 17" dengan resolusi 1440x900
yang menurut saya cukup kekecilan untuk mata saya. Jika resolusi 17" tersebut kekecilan, berapa yang
"tidak kekecilan" bagi saya? Untuk itu, saya perlu mendefinisikan apa itu "kekecilan."

"Terlalu kecil" terkait dengan ukuran teks-teks yang ada di layar. Itu definisi "terlalu kecil" yang
cukup jelas. Baiklah, question time! Pastinya akan muncul pertanyaan, "kalau teksnya kekecilan, ya
yang digedein teksnya! Bukan monitornya!" Tepat sekali. Itulah yang dilakukan para pengguna Mac
Retina Display. Di MBPr, ada setting bernama "scaled resolution" yang melakukan emulasi resolusi
layar ke resolusi "yang diinginkan". Sekali lagi, ini emulasi. Yang di-render sebenarnya tetap
resolusi native. Oleh karena itulah, kalau mengembangkan aplikasi untuk Mac, kita perlu menyertakan
raster untuk DPI yang berbeda -- agar hasil rendernya optimal.

Sayang sekali, emulasi resolusi ("scaled resolution") hanya ada di Mac. Android memang memiliki
fitur membesarkan ukuran teks, tetapi hanya teks. Untuk memperburuk suasana, tidak semua aplikasi
*respect* dengan setelan ukuran teks ini. Alasannya karena layout nya nanti rusak, katanya.

Windows juga memiliki fitur "membesarkan ukuran". Sayang sekali, pengaturan ini tidak berjalan
dengan semestinya. Beberapa program malah rusak dan tidak *respect* dengan setelan ini.

Oleh karena itu, daripada bergantung dengan software dan saya belum bisa mengafford Mac, jadi
lebih baik saya mencari monitor yang menghasilkan teks yang lebih besar. Dan tentu saja, space
yang lebih lega -- akan tetapi ukuran teks yang lebih besar menjadi penting.

Ukuran teks bisa dinilai dari ppi. Makin tinggi angka ppi, maka makin kecil piksel yang dihasilkan,
maka makin kecil ukuran teksnya. Oleh karena itu, saya perlu mengukur berapa "ppi" yang pas
untuk saya. Setelah melihat banyak sekali monitor, saya layar 19" dengan resolusi 1440x900 sangat
cocok untuk mata saya. Ukurannya enggak bikin sakit untuk dilihat dalam waktu lama. Akan tetapi,
ruang 1440x900 terlalu kecil untuk saya, maka saya perlu mencari ruang yang lebih besar.

Jadi, saya akan mencari monitor dengan ppi yang lebih rendah / mendekati ppi monitor 1440x900 di
19" dengan resolusi yang lebih tinggi. Awalnya, saya sangat kesemsem dengan layar 2K di
ukuran 27". Akan tetapi, setelah mengetahui harga monitor 4K tidak jauh berbeda, saya jadi
kesemsem juga.

Sayang sekali, ketika melihat ppi nya, saya kecewa. Berikut rangkuman kalkulasi PPI nya:

```

1440x900
	- 17: 99 <--- Terlalu kecil
	- 19: 89 <--- Ideal

1920x1080
	- 22: 100
	- 23: 95 <-- Terlihat acceptable
	- 24: 91 <-- Sepertinya cukup
	- 25: 88 <-- Ideal
	- 27: 81 <-- Terlalu besar? Kecuali meja saya juga panjang

2560x1440
	- 25: 117
	- 27: 108
	- 32: 92

4K
  - 34: 86


```

Untuk kondisi sekarang, ukurang yang ideal adalah 24-25 dengan resolusi FHD. Lebih tinggi dari itu,
memang space nya cukup lapang (resolusinya lebih tinggi), namun sayangkan ppi terlalu kecil untuk
saya.

Ya begitulah.

Tentu saja, ppi yang nyaman untuk setiap orang berbeda-beda :D
