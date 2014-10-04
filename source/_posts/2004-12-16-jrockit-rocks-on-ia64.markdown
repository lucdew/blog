--- 
layout: post
date: 2004-12-16
title: JRockit rocks on IA64
wordpress_id: 128
wordpress_url: http://www.dewavrin.info/?p=128
comments: true
categories: 
- weblogic
tags:
- weblogic
- jrockit

permalink: jrockit-rocks-on-ia64
---
I did some benchmark on a web application which runs on [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues")8.1 sp2. [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") was installed on a 4 IA64 CPU Linux server .<br /> The benchmark between the Sun JVM 1.4.1 for IA64 and the BEA JRockit providedwith [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") showed that the <b>application ran 10x times fasteron JRockit</b>. The ratio was even higher with more than 50 virtual users.

I couldn&#39;t even believe it. I thought I had done mistakes trying to tunethe Sun JVM with the -XX options but no the results were the samewithout the -XX options. I haven&#39;t figured outwhy the Sun JVM ran so slowly... But if you need to run [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues")server on IA64 give JRockit a try, it&#39;s really worth it.

To be honest, the Sun JVM 1.4.1 for Itanium 64seems to be a beta one (java -version gives build 1.4.1-b21) and the JRockit JVM is the only one supported on IA64 by BEA. So the comparision was obviously biased. By the way,i&#39;ll do some tests with [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") 8.1 sp4 with a JVM 1.4.2
