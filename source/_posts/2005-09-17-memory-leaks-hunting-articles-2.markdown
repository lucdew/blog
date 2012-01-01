--- 
layout: post
title: Memory leaks hunting articles
wordpress_id: 203
wordpress_url: http://www.dewavrin.info/?p=203
categories: 
- weblogic
tags: []

---

I have been busy lately and once again I will only add interesting links. These are about memory leaks hunting in the JVM. Memory leaks can be hard to spot and these articles were published while I was facing the same problems in my company. So thanks to Java's community, I have been able to quickly identify the potential origins of the leaks. 
Read this very interesting article which also has links to other blogs which deal the issues of using ThreadLocal. [The Art of war blog](http://www.patrickpeak.com/page/patrick/20050614#your_web_app_is_leaking)
And this article about Java threads stack which can lead, when not properly sized, to "Out of memory exceptions" even with enough free heap space and lost threads.[http://www.javablogs.com/Jump.action?id=215672]() And this thread about -Xss JVM option and ulimit on Linux [http://forum.java.sun.com/thread.jspa?threadID=261344&tstart=0](http://forum.java.sun.com/thread.jspa?threadID=261344&tstart=0)
