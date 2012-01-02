--- 
layout: post
title: Java on FreeBSD
wordpress_id: 194
wordpress_url: http://www.dewavrin.info/?p=194
categories: 
- java
tags:
- freebsd

---
Hey, great ! Sun and FreeBSD agreed on Java distribution and now J2SDK can get distributed with FreeBSD. No more get linux-compat <span>=&gt; get a JDK =&gt; get Java sources =&gt;</span> Compile and package to run Java "natively" on FreeBSD (without Linux compatibility ).

It took at least 6 hours on my slow home gateway. Also it seems to run much faster, see the results of my very serious test (2nd invokation of java -version)

{% codeblock %}
java version "1.5.0-p2"
Java(TM) 2 Runtime Environment, Standard Edition (build 1.5.0-p2-root_16_jan_2006_15_45)
Java HotSpot(TM) Client VM (build 1.5.0-p2-root_16_jan_2006_15_45, mixed mode)
 
real    0m3.232s
user    0m1.679s
sys     0m1.468s
 
java version "1.5.0"
Java(TM) 2 Runtime Environment, Standard Edition (build diablo-1.5.0-b00)
Java HotSpot(TM) Client VM (build diablo-1.5.0_06-b00, mixed mode)
 
real    0m0.643s
user    0m0.556s
sys     0m0.070s
{% endcodeblock %}
