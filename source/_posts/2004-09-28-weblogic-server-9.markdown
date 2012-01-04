--- 
layout: post
title: Weblogic server 9
wordpress_id: 132
wordpress_url: http://www.dewavrin.info/?p=132
comments: true
categories: 
- general
tags:
- weblogic

---

Yesterday,I attented the online conference about [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server 9 "Operation Administration andmaintainance" . Well, here are some of the enhancements I noted:
- The administration console won't use an applet anymore but a Strutsbased application. It will allow to do multiple operations and validatethem at once. There will also have an "undo" command.
 _Update: I have forgotten to say that BEA confirmed that WLST jython based scripting language will now be part of the product. That's one more reason to learn Jython_
- Hot redeployment of a Web application without service disruption.This feature is only available for Web application. For me it's not amajor feature since a load balancer or Apache (with very little downtime) can do the job but it requires at least 2 instances of [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server.
- [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") Diagnostic Framework: it will give the ability to do morefine grained instrumentation of application and [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") serverservices. This framework is AOP based.
- J2EE 1.4 compliance.
- performance boost (without more precision ...)

Well as you can notice the improvements are not revolutionnary and I think it shows that this product has really come to maturity (in termsof administration). By the way, the beta will be available in the beginning of November. Since the presentation was public I have uploaded a screenshot of the new console:![WLS9 console](http://www.jroller.com/resources/l/ldewavrin/console.jpg)
