---
layout: post
title: "Proxy UI"
date: 2012-10-01 06:37
comments: true
categories: linux
lang: id
---

Tadinya mau download dari server

	muhammad.mufid@ipin:~$ env | grep proxy
	http_proxy=http://proxy.ui.ac.id:8080
	https_proxy=https://proxy.ui.ac.id:8080
	muhammad.mufid@ipin:~$ wget google.com
	--2012-09-28 15:28:06--  http://google.com/
	Resolving proxy.ui.ac.id... 152.118.24.10, 2403:da00:1:3::a
	Connecting to proxy.ui.ac.id|152.118.24.10|:8080... connected.
	Proxy request sent, awaiting response... 403 Forbidden
	2012-09-28 15:28:06 ERROR 403: Forbidden.

Ternyata sangat aman :)