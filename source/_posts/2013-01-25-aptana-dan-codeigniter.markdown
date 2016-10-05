---
layout: post
title: "Aptana dan Codeigniter"
date: 2013-01-25 02:05
comments: true
categories: aptana, php
lang: id
---

Baiklah, Anda ingin agar Aptana Anda menjalankan autocompletenya CI?

Sederhana. Simpan file ini sebagai php dalam project CI Anda. Simpan dimanapun, terserah Anda.

{% codeblock aptana-ci-autocomplete.php %}
<?php

class _
{
    function _()
    {

    // any classes you want included in autocompletion
    $this->load = new CI_Loader();
    $this->config = new CI_Config();
    $this->email = new CI_Email();
    $this->encrypt = new CI_Encrypt();
    $this->pagination = new CI_Pagination;
    $this->session = new CI_Session();
    $this->driver = new CI_Driver();
    $this->benchmark = new CI_Benchmark();
    $this->typography = new CI_Typography();
    $this->form_validation = new CI_Form_validation();
    $this->profiler = new CI_Profiler();
    $this->image_lib = new CI_Image_lib();
    $this->math = new Math();
    $this->calendar = new CI_Calendar();
    $this->db = new CI_DB_active_record();
    $this->table = new CI_Table();
    $this->table = new MY_Table();
    $this->ftp = new CI_FTP();
    $this->output = new CI_Output();
    $this->javascript = new CI_Javascript();

    // note you'll need to use $this->CI = & getInstance() in extended libs
    // in order for the CI to autocomplete
    $this->CI=new CI_Controller();

    }

}

// any classes you want autocomplete for
class CI_Controller extends _ {}
class CI_Model extends _ {}
class CI_Form_validation extends _ {}
class CI_Table extends _ {}
?>
{% endcodeblock %}

Jika Anda memiliki kepustakaan tersendiri yang ingin dimasukkan dalam autocomplete, Saya pikir Anda sudah mendapatkan idenya. Tambahkan ke dalam $this.

<http://ellislab.com/forums/viewthread/187641/>
