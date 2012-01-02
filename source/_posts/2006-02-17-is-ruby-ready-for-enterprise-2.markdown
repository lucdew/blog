--- 
layout: post
title: Is Ruby ready for enterprise ?
wordpress_id: 198
wordpress_url: http://www.dewavrin.info/?p=198
categories: 
- general
tags:
- ruby

---

I have been attracted by the horns and whistles of Ruby (and Rails) and recently I decided to jump on the bandwagon.

I had to code a script that polls SNMP agents. Since there's a decent ruby SNMP library on the net, I decided to code it in Ruby and also because it's easy to create a Windows executable with ruby2exe.rb ruby script.

But here's why I have been disappointed by some aspects of "ruby the platform" during this coding session:
-  Ruby doesn't support Unicode strings yet. Try to do: a=\'café\'b=a\[0,3\] and you'll get an error (not the proper character).  A character is today encoded in a single byte. Well there are some workarounds explained [here](http://wiki.rubyonrails.org/rails/pages/HowToUseUnicodeStrings) but no perfect solutions until the support of multilinguism in the language itself.
-  No XML validation. The REXML library included in Ruby distribution does not support validation of an XML document on a XML schema. Some third-party libraries like libxml seem to support it but they are partially coded in C
-  The ruby interactive interpreter does not support French keyboard on Windows and i can't type the \[ character.

If I appreciate the language syntax, I don't understand how can some bloggers encourage Java coders to move to Ruby and Rails. ruby "the platform" doesn't seem really mature.
