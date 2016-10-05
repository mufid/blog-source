---
layout: post
title: "Using Class with Generics &lt;T&gt; Without the T in C#"
date: 2016-05-04 06:51
comments: true
categories:
keywords_seo: c#, csharp, design pattern
---

So lately I have been developing a C# application with Xamarin. Then I faced a design problem where I should be able to call a function inside a class with generic type, but I don't know what is the generic type. Furthermore, I don't care what is the type of the generic.

Imagine a situation like this: I have a class like this:

{% codeblock lang:csharp %}
Wrapper<T> where T : IDestroyable
{
  T RetrieveValue() { /* body */ }
  void Destroy() { /* body */ }
}
{% endcodeblock %}

Let's go straight to the point: What if I want to call Destroy, but I don't care what is T? So I have

{% codeblock lang:csharp %}
object x // instance of Wrapper
{% endcodeblock %}

`object x` is an instance of `Wrapper`. But I can't cast it into wrapper without knowing the exact value of the generic type. I can't do something like this:

{% codeblock lang:csharp %}
Object x = something;
(X as Wrapper<?>).Destroy();
{% endcodeblock %}

Also, generic is tightly coupled in C#. Meanwhile, in Java, generic is optional. If you don't specify the generic, Java just simply treat the generic type as `Object`. In java you can write the code like below, but not in C#:

{% codeblock lang:csharp %}
(X as Wrapper).Destroy();
{% endcodeblock %}

So how do I call `Destroy` without knowing the `T`? Surprisingly, the solution is pretty simple. Just extract the `Destroy` method to an interface:

{% codeblock lang:csharp %}
interface IWrapperDestroyer
{
  void Destroy()
}

Wrapper<T> : IWrapperDestroyer where T : IDestroyable
{
  T RetrieveValue()
  void Destroy()
}
{% endcodeblock %}

So that I can simply call this:

{% codeblock lang:csharp %}
(X as IWrapperDestroyer).Destroy()
{% endcodeblock %}

Perhaps the next question is, why we get `x` as an `object` type at the first place? Why don't we just simply make it stronger type to `Wrapper` with known `T`? I don't know. Perhaps because I am working too much with reflection since I am creating Xamarin-based Android and iOS application with MvvmCross.