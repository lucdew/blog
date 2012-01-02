--- 
layout: post
title: Websphered
wordpress_id: 123
wordpress_url: http://www.dewavrin.info/?p=123
categories: 
- java
tags:
- websphere

---
Currently, I am learning Websphere 5.1 administration and I am amazed howsimilar it is to Weblogic Server 8.1. OK, they are both J2EE 1.3 applicationservers but even in non specified fields they look similar. They clearly seemto have copied one another.<br />For example, the Websphere &#39;s wsadmin tool can now be used in Jython scripts like Weblogic&#39;sWLST. Weblogic Diablo&#39;s v9 console will support atomic operations and will be basedon a Struts app like Websphere console,etc. <br />I liked the Websphere SOAP JMX connector feature and more globally its integration with IBM products family (or sphere I should say). But this latter point seems also to be its weakness because it seems to be less open than Weblogic ( for example on JVM side and security authenticators). I haven&#39;t studied Websphere&#39;s cluster capabilities but Weblogic ones are "good" in repect to EJB CMP entities clustering (for JMS its another issue...). The problem is that Weblogic cluster additionnal features for CMP EJBs like lazy loading for finders or relations, caching for read-only or optimistic concurrency strategies are often unknown by developers (another issue too...). My first impressions on Websphere on v5.1 are good, better than I expected (last time I used Websphere was for v3.5...)<br />
