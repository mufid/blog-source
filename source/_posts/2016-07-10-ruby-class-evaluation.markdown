---
layout: post
title: "In Ruby, Everything is Evaluated"
date: 2016-07-10 22:25
comments: true
categories:
lang: en
---

So if i write

{% codeblock lang:ruby %}
def hello
  puts 'world'
end
{% endcodeblock %}

It will evaluate `def`, to which Ruby will "create a method named hello in global scope, with puts 'world' as a block". We can change "global scope" to any object we want.

{% codeblock lang:ruby %}
class Greeting
  def hello
    puts 'world'
  end
end
{% endcodeblock %}

The class "Greeting" is actually EVALUATED, NOT DEFINED (e.g. In Java, after we define a signature of a class/method, we can't change it, except using reflection). So actually, we can put anything in "Greeting" block, like

{% codeblock lang:ruby %}
class Greeting
  puts "Will define hello in greeting"
  def hello
    puts 'world'
  end
end
{% endcodeblock %}

Save above script as "test.rb" (or anything) and try to run it. It will show "Will define hello in greeting" EVEN you don't call "Greeting" class or "hello" class or you don't even need to instantiate "Greeting" class. This language feature allows meta programming, like what we see in Rails.

This time i will use Class Attribute within active support. If you ever run Rails, you should have it, but you can `gem install active_support` if you don't.

{% codeblock lang:ruby %}
require 'active_support/core_ext/class/attribute'

module Greeting; end

class Greeting::Base

  class_attribute :blocks

  def hello(name)
    self.blocks[:greeting].call(name)
    self.blocks[:hello].call(name)
  end

  protected
  def self.define_greeting(sym, &blk)
    self.blocks ||= {}
    self.blocks[sym] = blk
  end
end

class Greeting::English < Greeting::Base
  define_greeting :greeting do |who|
    puts "Hi #{who}, Ruby will greet you with hello world!"
  end
  define_greeting :hello do |who|
    puts "Hello World, #{who}!"
  end
end

class Greeting::Indonesian < Greeting::Base
  define_greeting :greeting do |who|
    puts "Halo kakak #{who}, Ruby akan menyapamu dengan Halo Dunia!"
  end
  define_greeting :hello do |who|
    puts "Halo dunia! Salam, #{who}!"
  end
end

x = Greeting::English.new
x.hello "Fido"
# Hi Fido, Ruby will greet you with hello world!
# Hello World, Fido!
x = Greeting::Indonesian.new
x.hello "Fido"
# Halo kakak Fido, Ruby akan menyapamu dengan Halo Dunia!
# Halo dunia! Salam, Fido!
{% endcodeblock %}

Previously i want to move the class attribute logic to above code, but after i see the [Active Support code](https://github.com/rails/rails/blob/e35b98e6f5c54330245645f2ed40d56c74538902/activesupport/lib/active_support/core_ext/class/attribute.rb), it is pretty complex, so i just require it : /

----

Previously, i posted [this in Reddit](https://www.reddit.com/r/ProgrammerTIL/comments/4s2vmr/ruby_til_in_ruby_everything_is_evaluated/)