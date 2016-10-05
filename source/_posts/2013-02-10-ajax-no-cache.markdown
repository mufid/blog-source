---
layout: post
title: "AJAX No-Cache"
date: 2013-02-10 14:09
comments: true
categories:
lang: id
---

Sebetulnya, ini tidak hanya berlaku pada URI yang mengandung *AJAX Call*, tetapi juga untuk semua URI yang datanya pasti berubah.

{% codeblock header-no-cache.php %}
<?php

$this->output->set_header('Pragma: no-cache');
$this->output->set_header('Cache-Control: no-cache, must-revalidate');
$this->output->set_header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');

{% endcodeblock %}

Meski Internet Explorer memiliki masalah pada pemanggilan AJAX (karena meski header ini sudah diset, IE tetap saja mengambil dari cache), dari tautan yang saya temui ada [empat solusi atas semua ini](https://devcentral.f5.com/blogs/us/fixing-internet-explorer-amp-ajax).

Sumber: <http://ellislab.com/forums/viewthread/155976/>