--- 
layout: post
date: 2006-06-13
title: Spring and Lingo = Easy JMS
wordpress_id: 190
wordpress_url: http://www.dewavrin.info/?p=190
comments: true
categories: 
- java
tags: 
- jms
- lingo
- spring
permalink: spring-and-lingo-easy-jms-2
---
With [Lingo](http://lingo.codehaus.org/) from codeHaus, Spring remoting can be extended to support JMS.Here's a great article on [Saniv Jivan's blog](http://www.jroller.com/page/sjivan?entry=asynchronous_calls_and_callbacks_using) that shows some of its capabilities (synchronous calls over JMS and asynchronous callbacks).

One feature really seducing is asynchronous callbacks over JMSwith POJOS (without a single line of JMS code).The Lingo site does not provide much documentation on itso thanks for the author of this nice article.

We applied this technique for our build system to distribute loadon different machines to speed up the process (we only have mono processor build machines) and gets informed when tasks are done via callbacks.We used Spring 2.0M4 and ActiveMQ 3.2.2 in standalone mode.

Note that I had troubles to make it run with Websphere MQ 5.3First, recent MQ JMS 1.1 compliant Jars must be used anda misinterpretation of the JMS specs by Websphere seems to breakthe Lingo Spring JMS service exporter see[http://opensource.atlassian.com/projects/spring/browse/SPR-1324](http://opensource.atlassian.com/projects/spring/browse/SPR-1324)which is for JMS templates but can also be applied to lingo.

Here's the diff of org.logicblaze.lingo.jms.JmsServiceExporter between unpatched and patched version for Websphere MQ:


{% codeblock lang:text %}
diff -aur lingo-1.1/src/java/org/logicblaze/lingo/jms/JmsServiceExporter.java li
ngo-1.1-patch/src/java/org/logicblaze/lingo/jms/JmsServiceExporter.java
--- lingo-1.1/src/java/org/logicblaze/lingo/jms/JmsServiceExporter.java 2006-06-
13 13:45:12.716722400 +0200
+++ lingo-1.1-patch/src/java/org/logicblaze/lingo/jms/JmsServiceExporter.java200
6-06-13 13:44:49.899847100 +0200
@@ -180,7 +180,7 @@
 
}
else {
-            return session.createConsumer(destination, messageSelector, noLocal
);
+            return session.createConsumer(destination, messageSelector);
}
}
{% endcodeblock %}
