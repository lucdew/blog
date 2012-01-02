--- 
layout: post
title: Article on Spring and AOP
wordpress_id: 200
wordpress_url: http://www.dewavrin.info/?p=200
categories: 
- java
tags:
- spring
- aop
---

An excellent article on [Spring, AOP, EJBs and testing ](http://dev2dev.bea.com/pub/a/2005/12/spring-aop-with-ejb.html) has been published on dev2dev.bea.com from Eugene Kuleshov. It's intended for Spring newcomers and intermediate users. I have just read it and highly recommand it.

It deals with:
- Simplifying usage of EJB (SSB here) by delegating to Spring beans and how to inject Spring beans in EJBs
- Weaving application logic in Spring beans without modifying them using AOP
- Testing techniques by mocking beans which rely on infrastructure components with Junit and JMock


I wasn't aware of using Spring's BeanPostProcessor to switch beans at runtime which prevents from writing another applicationContext.xml file for testing.
