---
layout: post
title: Rails Static Router
date: 2019-09-28 15:34
comments: true
categories:
lang: en
---

One year ago, I need to serve single page on asset folder in my Rails application. However,
I can't use Nginx to directly serve the file since preprocessing is required by Rack middleware.
Also, all of the assets is served via CDN and I can't simply redirect the path into CDN, as
JEB path my change dependencing on CDN configuration.
Then I found following [StackOverflow question](https://stackoverflow.com/questions/12608424/serving-static-html-in-rails-with-a-layout-file):

<!-- more -->

![Stackoverflow Question](/images/post/rails-static-router-1.png)

The first answer pointed me to use [High Voltage](https://github.com/thoughtbot/high_voltage)
gem. However, I think it is overkill. I don't need to serve dozens of page.

I then opened another [Stackoverflow Question](https://stackoverflow.com/questions/5631145/routing-to-static-html-page-in-public/43183300#43183300):

![Stackoverflow Question](/images/post/rails-static-router-2.png)

The next answer is fairly fit my needs. It only need add 1 file to
my Rails installation, then I only need add `static(filename)` to
my `routes.rb`. Very great!

The answer was from Eliot Sykes. However, it wasn't work for Rails 5 and
I need a little tweak to make it works. After all, the tweak works
and I can use his code on my project.

Weeks later, I needed to put it into my another project. 
I need to copy the single lib file to my new project. Yes, only
single file. But it would be very nice if it is packaged as a
Rubygem. I asked Eliot if I can publish the Rubygem within his
name. He asked me back how about I publish the Rubygem as he
is no more maintaining the library. He give me permission
to fork the project and then redirect the original repo to
my repo.

Currently, I maintained the library and I make sure
the library is compatible with the latest Rails version.

If your use case fits the library purpose, go ahead
[visit the repo and install it into your Rails project](https://github.com/mufid/rails-static-router).

Hope it helps!

