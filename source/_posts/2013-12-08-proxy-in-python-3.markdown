---
layout: post
title: Membuat Proxy Server di Python 3
date: 2013-12-08 04:58
comments: true
categories:
lang: id
---

Wah lama gak ngepost :D

Baiklah, jadi ceritanya ada tugas jaringan komputer dan ini membuat Proxy. Mari kita buat hidup kita lebih sederhana dengan memahami bagaimana proxy bekerja.

Berhubung ini adalah post Proof of Concept, maka post kali ini akan sangat panjang. Pastikan Anda sudah membeli Siomay atau Pizza untuk menemani Anda membaca post ini. Atau Anda juga dapat [menyiapkan anime yang menggugah semangat untuk menambah semangat Anda dalam membaca post ini](http://myanimelist.net/anime/6547/Angel_Beats!).

Selamat menikmati! (makanan dan postnya, tentu saja).

(Note: Saya mohon kritik Anda apabila penjelasan saya di sini ada yang misleading atau sulit dipahami. Dengan demikian saya bisa menghasilkan tulisan dengan kualitas tulisan yang lebih baik lagi ^_^)

<!-- more -->

## The Tools

Agar hidup ini lebih menyenangkan saat menggunakkan Windows, saya menggunakkan beberapa perkakas seperti Mingw dan PyCharm. Semua tools tersebut tersedia gratis di internet.

## The Proxy

`mahasiswa.cs.ui.ac.id` adalah sebuah server web yang melayani halaman `public_html` dari setiap `~` (home folder) mahasiswa CSUI ke internet publik. Mari kita lihat apa yang terjadi apabila saya membuka halaman web mahasiswa.cs.ui.ac.id. Tentu saja, di sini saya memakai "debug mode". Kita gunakan `curl` dengan verbose mode agar dapat mengetahui apa yang sebenarnya terjadi.

	D:\tmp>curl -v mahasiswa.cs.ui.ac.id
	* Adding handle: conn: 0x4c2cf0
	* Adding handle: send: 0
	* Adding handle: recv: 0
	* Curl_addHandleToPipeline: length: 1
	* - Conn 0 (0x4c2cf0) send_pipe: 1, recv_pipe: 0
	* About to connect() to mahasiswa.cs.ui.ac.id port 80 (#0)
	*   Trying 152.118.148.93...
	* Connected to mahasiswa.cs.ui.ac.id (152.118.148.93) port a80 (#0)
	> GET / HTTP/1.1
	> User-Agent: curl/7.30.0
	> Host: mahasiswa.cs.ui.ac.id
	> Accept: */*
	>
	< HTTP/1.1 200 OK
	< Date: Sat, 07 Dec 2013 22:01:58 GMT
	* Server Apache/2.2.22 (Debian) is not blacklisted
	< Server: Apache/2.2.22 (Debian)
	< Last-Modified: Tue, 27 Mar 2012 14:08:11 GMT
	< ETag: "5ba68-b1-4bc3a055dc8c0"
	< Accept-Ranges: bytes
	< Content-Length: 177
	< Vary: Accept-Encoding
	< Content-Type: text/html
	< Via: 1.1 mahasiswa.cs.ui.ac.id
	<
	<html><body><h1>It works!</h1>
	<p>This is the default web page for this server.</p>
	<p>The web server software is running but no content has been added, yet.</p>
	</body></html>
	* Connection #0 to host mahasiswa.cs.ui.ac.id left intact

	D:\tmp>

**Apa yang sebenarnya terjadi?**

Dalam mengakses internet, client (bisa browser, bisa program kecil seperti curl/wget, etc.) akan membuka koneksi ke server melalui socket. Apa yang client kirimkan setelah membuka koneksi? Mengirimkan baris-baris yang ditandai dengan `>`. Setelah `\r\n` kosong, server akan menganggap client selesai mengirimkan **HTTP Request** dan akan memulai memberikan respons (**HTTP Response**) yang ditandai dengan `<`.

Tugas Proxy sederhana. Dia menjadi jembatan antara Client dan Server. Tetapi yang menarik adalah **Proxy behave sebagai server sungguhan dengan hanya menyunting satu baris saja**. Kita lihat apa yang terjadi jika kita mengatur proxy di komputer kita. Kali ini saya akan memakai proxy fiktif. Fokus kita di sini adalah mengetahui bagian apa yang berubah.

	D:\tmp>set HTTP_PROXY=http://example.com:80

	D:\tmp>curl mahasiswa.cs.ui.ac.id -v
	* Adding handle: conn: 0x4c2d10
	* Adding handle: send: 0
	* Adding handle: recv: 0
	* Curl_addHandleToPipeline: length: 1
	* - Conn 0 (0x4c2d10) send_pipe: 1, recv_pipe: 0
	* About to connect() to proxy example.com port 80 (#0)
	*   Trying 93.184.216.119...
	* Connected to example.com (93.184.216.119) port 80 (#0)
	> GET HTTP://mahasiswa.cs.ui.ac.id/ HTTP/1.1
	> User-Agent: curl/7.30.0
	> Host: mahasiswa.cs.ui.ac.id
	> Accept: */*
	> Proxy-Connection: Keep-Alive
	>
	* HTTP 1.0, assume close after body
	< HTTP/1.0 400 Bad Request
	< Content-Type: text/html
	< Content-Length: 349
	< Connection: close
	< Date: Sat, 07 Dec 2013 22:10:10 GMT
	< Server: ECSF (cpm/F9B9)
	<
	<?xml version="1.0" encoding="iso-8859-1"?>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	        <head>
	                <title>400 - Bad Request</title>
	        </head>
	        <body>
	                <h1>400 - Bad Request</h1>
	        </body>
	</html>
	* Closing connection 0

	D:\tmp>

Lihat bagian yang berubah? Pertama lihat baris pertama. Tadinya adalah alamat relatif terhadap host. Sekarang adalah alamat absolut. Yosh, hanya bagian itu saja. Sisanya, proxy hanya meneruskan data-data dari server (sebetulnya bisa iseng sedikit seperti mengambil password, tetapi itu di luar bahasan kita).

## In a Nutshell (Dalam Kulit Kacang)

	Client
	  |       Proxy bertindak seolah-olah sebagai server*
	  |       jika dilihat oleh client
	  |
	Proxy
	  |       Proxy bertindak seolah-olah sebagai client
	  |       jika dilihat oleh server
	  |
	Server

## The Code

Kode Templatenya adalah sebagai berikut:

{% codeblock proxy-keren.py lang:python %}
	from socket import *
	import sys

	# Create a server socket, bind it to a port and start listening
	tcpSerSock = socket(AF_INET, SOCK_STREAM)
	# Fill in start.
	# PART 1
	# Fill in end.
	while 1:
	  # Strat receiving data from the client
	  print ("Ready to serve...")
	  tcpCliSock, addr = tcpSerSock.accept()
	  message = # PART 2
	  print (message)
	  # Extract the filename from the given message
	  print (message.split()[1])
	  filename = message.split()[1].partition("/")[2]
	  print (filename)
	  fileExist = "false"
	  filetouse = "/" + filename
	  print (filetouse)

	  try:
	    # Check wether the file exist in the cache
	    f = open(filetouse[1:], "r")
	    outputdata = f.readlines()
	    fileExist = "true"
	    # ProxyServer finds a cache hit and generates a response message
	    tcpCliSock.send("HTTP/1.0 200 OK\r\n")
	    tcpCliSock.send("Content-Type:text/html\r\n")
	    # Fill in start. # PART 3
	    # Fill in end.
	    print ("Read from cache")
	    # Error handling for file not found in cache
	  except IOError:
	    if fileExist == "false":
	      # Create a socket on the proxyserver
	      # c = # Fill in start. # Fill in end. # PART 4
	      hostn = filename.replace("www.","",1)
	      print (hostn)
	      try:
	        # Connect to the socket to port 80
	        # Fill in start. # PART 5
	        # Fill in end.
	        # Create a temporary file on this socket and ask port 80 for the file requested by the client
	        fileobj = c.makefile('rwb', 0)
	        strHeader=str.encode("GET "+"http://" + filename + " HTTP/1.0\n\n")
	        fileobj.write(strHeader)
	        # Read the response into buffer
	        # Fill in start. # PART 6
	        # Fill in end.
	        # Create a new file in the cache for the requested file.
	        # Also send the response in the buffer to client socket
	        # and the corresponding file in the cache
	        tmpFile = open("./" + filename,"wb")
	        # Fill in start. # PART 7
	        # Fill in end.
	      except:
	       print ("Illegal request")
	    else:
	       # HTTP response message for file not found
	       # Fill in start. # PART 8
	       # Fill in end.
	       # Close the client and the server sockets
	       tcpCliSock.close()

	# Fill in start. # PART 9
	# Fill in end.
{% endcodeblock %}


Mari kita mulai mengoding ~

## Part 1

Bagian yang paling mudah. Karena proxy bertindak seolah-olah sebagai server terhadap client, maka proxy harus membuka koneksi port ke client.

{% codeblock lang:python %}
	tcpSerSock.bind(("127.0.0.1", 8888))
	tcpSerSock.listen(10)
{% endcodeblock %}

Sepertinya baris kode tersebut self-explanatory, tidak perlu dijelaskan. Mungkin yang perlu Anda perhatikan di bagian `listen`. Apa maksud dari angka di `listen`? Baca [dokumentasinya](http://docs.python.org/3.3/library/socket.html#socket.socket.listen) saja ya :D

> **socket.listen(backlog)**
> Listen for connections made to the socket. The backlog argument specifies the maximum number of queued connections and should be at least 0; the maximum value is system-dependent (usually 5), the minimum value is forced to 0.

## Part 2

Bagian ini adalah bagian menerima koneksi dari client. Bagian ini agak tricky, tapi kita mulai dengan hal yang paling sampah terlebih dahulu:

{% codeblock lang:python %}
	  data = tcpCliSock.recv(10)
	  print(data)
	  message = data
{% endcodeblock %}

Mari kita coba bermain dengan curl lagi (jangan lupa menjalankan script python kesayangan kita ini terlebih dahulu). Tentu saja Anda dapat mengujinya dengan browser, tetapi buat saya atas-enter-atas-enter lebih menyenangkan daripada Alt-tab-mouse-klikkiri-go-f5-ctrlF5.

	D:\tmp>python proxy-keren.py
	Ready to serve...
	Received a connection from: ('127.0.0.1', 52799)
	b'GET HTTP:/'
	b'HTTP:/'

Kenapa kita hanya menerima 10 byte pertama saja? Karena kita mengatur buffer untuk proxy kita hanya 10 byte. Sebetulnya, kita tinggal mengganti saja menjadi > 10 byte. Tetapi ada constraint berikut di [dokumentasi Python](http://docs.python.org/3.3/library/socket.html#socket.socket.recv):

> **socket.recv(bufsize[, flags])**
> Receive data from the socket. The return value is a bytes object representing the data received. The maximum amount of data to be received at once is specified by bufsize. See the Unix manual page recv(2) for the meaning of the optional argument flags; it defaults to zero.

Kalau begitu, sebagaimana kita membaca file, mari kita baca socket hingga tidak ada isinya lagi. Ubah sedikit kodenya:

{% codeblock lang:python %}
	  emptybyte = False
	  message = bytes()
	  while (not emptybyte):
	    chunk = tcpCliSock.recv(16)
        print ("Chunk is")
	    print (chunk)
	    if chunk == b'':
	      emptybyte = True
	    else:
	      message += chunk
	  print(message)
{% endcodeblock %}

**Catatan Tambahan:** Sebetulnya Anda bisa saja memperbesar jumlah buffernya dan tidak melakukan looping, tetapi itu bukan implementasi yang baik. Meski implementasi chunk di sini lebih baik dibandingkan memperbesar buffer and do nothing, Anda tetap harus memikirkan kondisi terburuk semisal koneksi terputus di tengah jalan. Meski demikian, kita akan mengabaikan hal-hal seperti ini. Kita tidak sedang membuat proxy terbaik, tetapi kita sedang membuat proof of concept dari proxy.

Nanti dulu, kalau kita jalankan proxynya, kita akan terjebak dalam forever loop. NOOOO!!

	D:\tmp>python proxy-keren.py
	Ready to serve...
	Received a connection from: ('127.0.0.1', 53905)
	Chunk is
	b'GET HTTP://mahas'
	Chunk is
	b'iswa.cs.ui.ac.id'
	Chunk is
	b'/ HTTP/1.1\r\nUser'
	Chunk is
	b'-Agent: curl/7.3'
	Chunk is
	b'0.0\r\nHost: mahas'
	Chunk is
	b'iswa.cs.ui.ac.id'
	Chunk is
	b'\r\nAccept: */*\r\nP'
	Chunk is
	b'roxy-Connection:'
	Chunk is
	b' Keep-Alive\r\n\r\n'

Program berhenti di sana. Kenapa? Karena koneksi socket pasti akan selalu terjalin, kecuali client sudah menerima apa yang dia inginkan. Sedangkan di sini koneksi socket terjalin tetapi si client masih menunggu jawaban dari proxy. "Woy gw minta halaman mahasiswa.cs.ui.ac.id donk!" Dia akan terus menunggu dan menjalin hubungan hingga proxy memberikan balasannya. Maka dari itu kita terjebak dalam forever loop.

Client selesai memberikan informasi "gw butuh apa" setelah ada `\r\n\r\n` sesuai dengan spesifikasi [RFC 3507](http://www.apps.ietf.org/rfc/rfc3507.html). Maka dari itu, mari kita ubah sedikit kodenya:

{% codeblock %}
	  emptybyte = False
	  message = bytes()
	  while (not emptybyte):
	    chunk = tcpCliSock.recv(16)
	    print("Chunk is ")
	    print(chunk)
	    message += chunk
	    if message.endswith(bytes('\r\n\r\n'.encode('utf-8'))):
	      emptybyte = True
{% endcodeblock %}

Hasilnya:

	D:\tmp>python proxy-keren.py
	Ready to serve...
	Received a connection from: ('127.0.0.1', 53948)
	b'GET HTTP://mahasiswa.cs.ui.ac.id/ HTTP/1.1\r\nUser-Agent: curl/7.30.0\r\nHost: mahasiswa.cs.ui.ac.id\r\nAccept: */*\r\nProxy-Con
	nection: Keep-Alive\r\n\r\n'
	b'HTTP://mahasiswa.cs.ui.ac.id/'
	Traceback (most recent call last):
	  File "proxy-keren.py", line 26, in <module>
	    filename = message.split()[1].partition("/")[2]
	TypeError: expected bytes, bytearray or buffer compatible object

Terjadi kesalahan karena pada template asli, program berusaha untuk menganalisis data bytes yang dianggap sebagai string. Mudah sekali, ubah saja menjadi string

{% codeblock lang:python %}
	message_raw = message
	message = message.decode('utf-8')
	print (message)
{% endcodeblock %}

Message asli saya preserve dalam message_raw untuk kebutuhan kita di masa depan. Anda akan mengerti setelah beberapa puluh paragraf ini.

Tentu proxynya masih belum berjalan dengan baik dengan modifikasi ini. Mari kita lanjut ke part 4. What? Part 4? Iya, karena part 3 adalah fungsi membaca dari cache, sedangkan kita belum mengimplementasi fungsi menulis ke cache. Kalau tidak ada yang ditulis, mau baca apa?

## Part 4

Bagian ini mengatur bagaimana koneksi proxy ke server. Skenario aslinya adalah:

- Jika cache hit (halaman tersedia di cache), maka baca dari cache (Part 3).
- Jika tidak, maka berikan client data dari server (Part 4, ini).

Bagaimana kalau kita iseng? Jadi kita lakukan ini:

1. Memberikan seluruh data dari client ke server
1. Mengembalikan ke client seluruh data yang diterime oleh proxy dari server

BRILLIANT IDEA!?

No.

Karena kita harus mengubah baris pertama dari HTTP Request. Tetapi, mari kita coba dengan cara yang naive terlebih dahulu.

Tetapi sebelumnya, saya melihat kejanggalan di template ini. Mari kita lihat isi dari `filename` dari `hostn`:

{% codeblock lang:python %}
      hostn = filename.replace("www.","",1)
      print("filename is " + filename)
      print("hostn is " + hostn)
{% endcodeblock %}

Hasilnya:

	# window 1
	curl -v mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf

	# window 2
	...
	filename is /mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf
	hostn is /mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf

Seriously, hostnamenya adalah URI?

Kalau begitu, gunakan saja URI Parser dari Python.

Import modul berikut:

{% codeblock lang:python %}
	from urllib.parse import urlparse
{% endcodeblock %}

Ubah beberapa bagian di bawah Part 1:

{% codeblock lang:python %}
	  print (message.split()[1])
	  parsed_url = urlparse(message.split()[1])
{% endcodeblock %}

Di part 4 menjadi:

{% codeblock lang:python %}
      hostn = parsed_url.netloc
      filename = parsed_url.path
      port = 80 if None == parsed_url.port else parsed_url.port
	  full_path = hostn + filename
      c = socket(AF_INET, SOCK_STREAM)
{% endcodeblock %}

Jalankan kembali proxynya. Tadaaa!

	filename is /dadadada/dadskjfkdsljfskdljf
	hostn is mahasiswa.cs.ui.ac.id

Baiklah, tinggal satu langkah lagi. Mari buat koneksi baru dan mulai segalanya dari sini.

**Catatan**: Di sini saya tidak membuat port default adalah 80, karena sangat jelas: akses HTTP belum tentu hanya di port 80. Practically, bisa dimanapun.

**Catatan 2**: Saya membuat full_path untuk menyimpan cache. Kita akan gunakan di part selanjutnya.

## Part 5

Nothing to do here:

{% codeblock lang:python %}
	c.connect(hostn, port)
{% endcodeblock %}

Melakukan sambungan harus dalam blok try-catch.

## Part 5+

Saya menemukan kesalahan dalam template yang menggunakkan `\n\n` untuk line ending (yang seharusnya `\r\n`). Kemudian tidak adanya request header `Host` yang mana itu dibutuhkan oleh dispatcher / router untuk web worker. Baiklah, mari kita rubah sedikit pada bagian tersebut.

{% codeblock lang:python %}
        strHeader = str.encode("GET " + full_path + " HTTP/1.0\r\n")
	    strHeader += str.encode("Host: " + hostn + "\r\n")
	    strHeader += str.encode("\r\n")
        fileobj.write(strHeader)
{% endcodeblock %}

## Part 6

Lakukan hal yang serupa seperti saat kita membaca socket dari client. Tetapi berhubung template kita sudah menggunakkan makefile, jadi kehidupan kita sedikit lebih mudah.

> **Mengapa saat koneksi Client-Proxy kita tidak bisa menggunakkan makefile?** Saya belum tahu. Dugaan saya adalah karena client masih menunggu jawaban, tetapi mungkin Anda tertarik untuk mencoba pendekatan yang lain. Sedangkan di sini yang menjadi client adalah proxy, dan proxy sudah mengirimkan semua informasi header yang sehingga penantian jawabannya adalah suatu kepastian (HTTP Request sudah dikirim semua, tinggal menunggu response).

{% codeblock lang:python %}
        tcpCliSock.sendall(fileobj.readall())
{% endcodeblock %}

Btw, untuk sementara Anda bisa mengcomment bagian tmpFile agar program bisa berjalan dengan baik.

Mari kita coba lihat hasilnya pada kondisi saat ini, yihaa program berjalan sebagaimana mestinya!

	C:\Users\Mufid>curl -v mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf
	* Adding handle: conn: 0x982678
	* Adding handle: send: 0
	* Adding handle: recv: 0
	* Curl_addHandleToPipeline: length: 1
	* - Conn 0 (0x982678) send_pipe: 1, recv_pipe: 0
	* About to connect() to proxy localhost port 8888 (#0)
	*   Trying ::1...
	* Connection refused
	*   Trying 127.0.0.1...
	* Connected to localhost (127.0.0.1) port 8888 (#0)
	> GET HTTP://mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf HTTP/1.1
	> User-Agent: curl/7.30.0
	> Host: mahasiswa.cs.ui.ac.id
	> Accept: */*
	> Proxy-Connection: Keep-Alive
	>
	< HTTP/1.1 404 Not Found
	< Date: Sun, 08 Dec 2013 02:08:55 GMT
	* Server Apache/2.2.22 (Debian) is not blacklisted
	< Server: Apache/2.2.22 (Debian)
	< Vary: Accept-Encoding
	< Content-Length: 313
	< Content-Type: text/html; charset=iso-8859-1
	< Via: 1.0 mahasiswa.cs.ui.ac.id
	< Connection: close
	<
	<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
	<html><head>
	<title>404 Not Found</title>
	</head><body>
	<h1>Not Found</h1>
	<p>The requested URL /dadadada/dadskjfkdsljfskdljf was not found on this server.</p>
	<hr>
	<address>Apache/2.2.22 (Debian) Server at mahasiswa.cs.ui.ac.id Port 80</address>
	</body></html>
	* Closing connection 0

## Next Up: 404

Berhubung di tugas disebutkan tidak ada data yang disimpan untuk halaman 404, maka ya cukup jangan simpan jika itu halaman 404. Tetapi saya agak bingung bagaimana mengimplementasi ini. Jadi saya justru melakukan perubahan di Part 6:

{% codeblock lang:python %}
        if (response.decode('utf-8').split()[1].startswith('4')):
          tcpCliSock.send("HTTP/1.1 404 Not Found".encode('utf-8'))
          tcpCliSock.send("\0\r\n\r\n".encode('utf-8'))
          tcpCliSock.close()
          continue
{% endcodeblock %}

Bukan hanya 404, melainkan juga 4xx. Hal ini karena status 4xx menandakan kesalahan di permintaan.

	C:\Users\Mufid>curl -v mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf
	* Adding handle: conn: 0x1db2678
	* Adding handle: send: 0
	* Adding handle: recv: 0
	* Curl_addHandleToPipeline: length: 1
	* - Conn 0 (0x1db2678) send_pipe: 1, recv_pipe: 0
	* About to connect() to proxy localhost port 8888 (#0)
	*   Trying ::1...
	* Connection refused
	*   Trying 127.0.0.1...
	* Connected to localhost (127.0.0.1) port 8888 (#0)
	> GET HTTP://mahasiswa.cs.ui.ac.id/dadadada/dadskjfkdsljfskdljf HTTP/1.1
	> User-Agent: curl/7.30.0
	> Host: mahasiswa.cs.ui.ac.id
	> Accept: */*
	> Proxy-Connection: Keep-Alive
	>
	< HTTP/1.1 404 Not Found
	* no chunk, no close, no size. Assume close to signal end
	<
	* Closing connection 0

Okay, sudah lebih baik. Mari kita lanjut ke proses caching.

## Next up: POST Request

Post Request ini sangat tricky. Karena di request post, request body tidak kosong. Mari kita lihat:

	mingw $ curl -v mahasiswa.cs.ui.ac.id/~muhammad.mufid/ -XPOST -d ganteng=ya --trace-ascii /dev/stdout
	Warning: --trace-ascii overrides an earlier trace/verbose option
	== Info: Adding handle: conn: 0x1f739b8
	== Info: Adding handle: send: 0
	== Info: Adding handle: recv: 0
	== Info: Curl_addHandleToPipeline: length: 1
	== Info: - Conn 0 (0x1f739b8) send_pipe: 1, recv_pipe: 0
	== Info: About to connect() to proxy localhost port 8888 (#0)
	== Info:   Trying ::1...
	== Info: Connection refused
	== Info:   Trying 127.0.0.1...
	== Info: Connected to localhost (127.0.0.1) port 8888 (#0)
	=> Send header, 229 bytes (0xe5)
	0000: POST HTTP://mahasiswa.cs.ui.ac.id/~muhammad.mufid/ HTTP/1.1
	003d: User-Agent: curl/7.30.0
	0056: Host: mahasiswa.cs.ui.ac.id
	0073: Accept: */*
	0080: Proxy-Connection: Keep-Alive
	009e: Content-Length: 10
	00b2: Content-Type: application/x-www-form-urlencoded
	00e3:
	=> Send data, 10 bytes (0xa)
	0000: ganteng=ya
	== Info: upload completely sent off: 10 out of 10 bytes

.. dan ... loop forever.

Ini karena `\0\r\n\r\n` itu sebagai penanda antara request body dan request header. Maka dari itu, agar loopnya berjalan dengan baik, kita ubah sedikit programnya di bagian loop penerima request: Saya juga menambahkan `import re` di bagian tas karena kita akan menggunakkan regex agar hidup kita lebih menyenangkan

{% codeblock lang:python %}
	  CHUNK_SIZE = 16
	  emptybyte = False
	  message = bytes()
	  content_length = 0
	  while (not emptybyte):
	    chunk = tcpCliSock.recv(CHUNK_SIZE)
	    message += chunk
	    # Receive everything until the end of the time. No just kidding
	    # Until the end of HTTP Request. Please read RFC 3507
	    if message.endswith(b'\r\n\r\n'.encode('utf-8')):
	      emptybyte = True

	    # Detect end of POST request
	    regex_match = re.search(r"Content-Length: ([0-9]+)", message.decode('utf-8'))
	    if (regex_match):
	      content_length = (int) (regex_match.group(1))
	      # Check if everything has been send as expected
	      if (message[-content_length-4:-content_length] == b'\r\n\r\n'):
	        emptybyte = True
{% endcodeblock %}

Dan juga jangan lupa agar proxy mengirim ke server juga dengan request body dari client

{% codeblock lang:python %}
        fileobj = c.makefile('rwb', 0)
        request_name = message_raw.split(b' ', 2)[0]
        rest_of_request = message_raw.split(b'\r\n', 1)[1]
        strHeader = str.encode(request_name.decode('utf-8') + " " + filename + " HTTP/1.0\r\n")
        strHeader += rest_of_request
        fileobj.write(strHeader)
{% endcodeblock %}

## Part 7: Cache Write

Caching sederhana saja. Simpan segalanya di file. Tidak perlu membaca body, cukup simpan segala responsenya. Memang ini bukan praktik yang bagus, tetapi kita ingin mendapatkan segalanya serba cepat.

Dan, di sini saya tidak akan membuat hirarki cache dalam bentuk folder. Ini akan menambah kerumitan apabila dia ada parameter GET, atau URL ada informasi yang diencode dalam unicode.

Btw, saya juga tidak menyimpan cache apabila dia bukan method GET. Ya, agar lebih menyenangkan saja. Mosok iya kita ngirim form, terus dibalasnya lewat cache. Ibarat anda upload tugas, kemudian hasilnya selalu upload berhasil padahal sebenarnya telah lewat deadline (hal ini karena proxy membaca dari cache).

{% codeblock lang:python %}
        if (request_name != b'POST'):
          tmpFile = open("./" + full_path.replace("/", ""),"wb")
          tmpFile.write(response)
          tmpFile.close()
{% endcodeblock %}

## Part 3: Cache Read

Tidak ada yang istimewa di sini ~

{% codeblock lang:python %}
    # Check wether the file exist in the cache
    f = open(full_path.replace("/", ""), "rb")
    fileExist = True
    # ProxyServer finds a cache hit and generates a response message
    data = f.read()
    print(data)
    tcpCliSock.sendall(data)
    # Fill in start.
    # Fill in end.
    print ("Read from cache")
    tcpCliSock.close()
{% endcodeblock %}

## Done!

Ya, itu adalah penjelasan mengenai proxy jadi-jadian kita. Tidak sempurna memang, tetapi setidaknya Anda telah mengetahui bagaimana konsep HTTP bekerja.

## Some Trouble(shooting)

- Saat menjalankan di linux, socket tidak ditutup secara langsung jika kita mematikan proses pythonnya. Entah itu yang disebut zombie atau apa, tetapi yang pasti saya masih harus `kill -9` atau `killall` agar proxynya dapat berjalan setelah sebelumnya dimatikan.
- Dalam ngoding, saya kesulitan memahami tipe data Python. Akibatnya, saya menemui beberapa run time error terkait ini. Literal di python didefinisikan sebagai `L'sesuatu'` dengan `L` adalah simbol literalnya dan `sesuatu` adalah datanya. Anda tidak bisa melakukan concat (penggabungan) `b'Halo' + ' Dunia'`. Alih-alih, Anda harus melakukan penggabungan dalam tipe data yang sama
- Program proxy di atas tidak sempurna dan hanya diuji membuka `mahasiswa.cs.ui.ac.id/~muhammad.mufid`. Saat membuka web-web yang kompleks (misalnya scele), program tidak berjalan dengan baik. Masalah concurrency, i18n, tidak ditangani dengan baik.
- Melakukan decode dalam UTF-8 adalah ide yang buruk, tidak semua data diterima dalam UTF-8. Workaroundnya adalah hanya menggunakkan `byte` dalam setiap urusan pertukaran dan pemrosesan data.
- Part 8, seharusnya saya isi apa?