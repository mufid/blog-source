---
layout: post
title: "Redirection, Pikir Dua Kali!"
date: 2013-01-04 08:33
comments: true
categories:
lang: id
---

Jadi ceritanya saya dikasih tautan oleh teman tautan berikut:

	http://m.kompasiana.com/post/politik/2013/01/02/mari-menghujat-pks/

Wait, kenapa saya malah diarahkan ke halaman depan? Menghapus **m.** merupakan solusi. Jadi ceritanya:

	C:\Users\Mufid>curl --head http://m.kompasiana.com/post/politik/2013/01/02/mari-
	menghujat-pks/
	HTTP/1.1 302 Found
	Date: Fri, 04 Jan 2013 01:33:10 GMT
	Server: Apache/2.2.3 (Red Hat)
	X-Powered-By: PHP/5.3.17
	Location: http://www.kompasiana.com/home
	Content-Type: text/html; charset=UTF-8
	Connection: close

.. maksud Kompasiana itu sangat baik, jika dibuka dari mobile maka redirect ke versi m. Tetapi jika sebaliknya, membuka versi m dari desktop, justru diredirectnya ke halaman depan. Hmm.. Tidak intuitif sama sekali.

	C:\Users\Mufid\octopress>curl -A "Mozilla/5.0 (Linux;U; Android 2.1; en-us; Nexus One Build/ERD62) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17" --head http://m.kompasiana.com/post/politik/2013/01/02/mari-menghujat-pks/
	HTTP/1.1 200 OK
	Date: Fri, 04 Jan 2013 01:38:00 GMT
	Server: Apache/2.2.3 (Red Hat)
	X-Powered-By: PHP/5.3.17
	Content-Type: text/html; charset=UTF-8
	Connection: Keep-Alive
	Set-Cookie: h_50e40345a03098a22901b00a=50e40345a03098a22901b00a; expires=Sat, 05
	-Jan-2013 01:38:00 GMT

Moral of the story: Hati-hati dalam menggunakkan redirect yah.