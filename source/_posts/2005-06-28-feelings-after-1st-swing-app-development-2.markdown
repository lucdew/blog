--- 
layout: post
title: feelings after 1st Swing app development
wordpress_id: 206
wordpress_url: http://www.dewavrin.info/?p=206
comments: true
categories: 
- java
tags:
- swing

---

Lately I have been busy writing (partly in my spare time) my first (3 tiers) Swing app  for the company I work for. This app enables to monitor the different layers of a product we develop and sell.The product is deployed in many environments (testing, integration, QA,etc.) and in different version. We have to identify quickly what is deployed on what and sometimes monitor the different sub-components especially for pre-production and QA environments. The monitorong app has a tier on Weblogic which does all the monitoring activity and expose monitoringfunction via Webservices (and JMX) and a presentation tier which is small Swing GUI (about 10 screens).  My background in development is mostly server side based (Web and J2EE) and i consider myself as an occasional developer (I do/did mostly J2EE and system administration )

 So here are my "first impressions" about Swing:
I disliked:<br />
- **lack of high level components:** I have found that Swing API lacks high level components or richer components (like autocompleting editable combo box) and Swing is globally too low level in my taste.
- **bugs:** Even if the app is low featured I experimented some little bugs which have no (easy) workarounds and are only fixed in Java 1.5. Like in the following JProgressMonitor window, the cancel action doesn&#39;t work ([bug 4804458](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4804458)):

![](http://www.jroller.com/resources/l/ldewavrin/connect_diag.png)
<div align="center"><b><i>Discovering Weblogic servers using multicast</i></b></div>

- **Designing screens and forms**. Even if JGoodies FormLayout helped, the design takes time (much more thanfor Web) and I missed GUI Wysiwyg tools. I know there are a few, but I have been told that they produceawful code.

I liked:
- **One language** What I liked in writing Desktop application is that, compared to Web app devlopment, I have been able to write it in one language from the client part to the server side part (Web services). What i disklike in Web development today is the accumulation of different technologies for the presentation layer: XHTML,CSS, Javascript, server side scripting language (ASP,JSP,PHP,etc) and object language (C#,Java...). (Ok it doesn&#39;t help separating GUI design from GUI logic code but with GUI designers it could help).If you add learning of an MVC framework or component based framework it makes a lot to know. On the other hand, the knowledge of such MVC frameworks helped me designing the rich client app. Also, debbuging can become problematic with all these layers and sometimes erros in Javascript code occur due to errors on the server  part of the application... 
- **blogs resources** Thanks to the numerous bloggers who deal with Swing hacks everyday, it&#39;s been easy to enhance the UI and make it look quite nice. Doesn&#39;t this pic remind you (jroller reader) of a high ranked blog in Jroller.com :<br />![](http://www.jroller.com/resources/l/ldewavrin/ealisdiag.png)
- **Deployment** Deployment has not been an issue I just added a Java Web start link in my company&#39;s portal. Most workstations had JRE &gt; 1.4.2 installed on then
- **OS integration** My integration requirement was basic: a tray icon is displayed when the app is launched and icon changes when a component of the application being monitored doesn&#39;tnot work properly. But thanks to jdic components it has been straightforward to implement.<br />![](http://www.jroller.com/resources/l/ldewavrin/tray.PNG)

Overall, I enjoyed this experience. Hopefully for me this app is only used for internal purpose and isn't sold ;-) But developping it gave me a glimpse of what could be developping a Swing app.I am not sure if I'll invest more time in learning Swing, well at least professionnaly speaking.Not because I don't find it interesting or that Swing is inefficientbut mostly due to the fact that I think I'll never be hired for such knowledge here in France. IT jobs in developmentare moving to Eastern Europe or India and job opportunities in Swing development are very low and reserved for senior devs.
