--- 
layout: post
title: Interesting article about Weblogic Entity EJB clustering
wordpress_id: 122
wordpress_url: http://www.dewavrin.info/?p=122
comments: true
categories: 
- weblogic
tags:
- weblogic
- ejb

---
See Dmitri Maximovich&#39;s [Blog](http://www.jroller.com/page/maximdim/20050330#long_term_caching_of_cmp). With very interesting articles about:
- CMP entity Ejbs clustering behaviour regarding &#39;Optimistic concurrency&#39; strategy
- Weblogic server v9 new entity Ejb clustering features

If entity Ejbs 2.1 are a "nightmare" to develop and test compared to transparent persistence frameworks of POJOs like Hibernate, some containers like BEA&#39;s one offer nice features to build up a R/W <b>distributed cache</b> (of persistent data). 

But it&#39;s also true that some distributed cache products can also plug into hibernate... see [Hibernate&#39;s doc](http://www.hibernate.org/hib_docs/v3/reference/en/html/performance.html#performance-cache) and [Tangosol](http://www.hibernate.org/132.html)
