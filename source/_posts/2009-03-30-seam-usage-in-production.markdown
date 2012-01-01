--- 
layout: post
title: Seam usage in production
wordpress_id: 261
wordpress_url: http://www.dewavrin.info/?p=261
categories: 
- java
- tech
tags: 
- seam
---

There 's an interesting [thread](http://www.seamframework.org/Community/SeamInProfessionalUse) on the Seam forum about Seam in "profesional use". Performance and steep learning curve are often mentioned as drawbacks. 

Seam heavily relies on proxy based components created by javassist. And javassist is known to be unperformant [compared to cglib](https://jira.jboss.org/jira/browse/JBSEAM-1977). This library might have been chosen due to politic reason at JBoss. Seam Managed Persistence Context (SMPC) is also seen as a culprit but i guess that like many other frameworks you have to understand what's underneath the carpet, lazy loading in some use cases can really hit performance.

Scalability is not mentioned but i guess that since Seam is stateful it also can be an issue for large websites.

 For the learning curve, it might be true if you don't come from the JavaEE world or have never developed JSF applications. Seam still requires good knowledge of JSF 1.X and how it corrects it in many ways.  The request lifecycle is also complex albeit powerful.Also other "lightweight" JSF based frameworks are quoted like [makefaces](https://makefaces.dev.java.net/).

Seam for me is both a IOC container specialized for web development  and a web integration framework of Java EE (Ejb,Web beans), JBoss stack (jBPM, Drools, Richfaces, JSFUnit) and commonly used libraries (quartz,jfreechart, itext, javamail,etc.)  It also addresses many commonly asked features (conversations, mail sending, page caching,etc.)  I am not sure for the future of Seam. Seam 3 might be a complete rewrite due to support of JSF 2 and JSR-299 aka _Java Contexts and Dependency Injection_, but it is a comprehensive and efficient web framework with a decent IDE (JBoss tools).
