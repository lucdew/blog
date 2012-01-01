--- 
layout: post
title: Xfire with Jibx
wordpress_id: 226
wordpress_url: http://www.dewavrin.info/?p=226
categories: 
- tech
tags: 
- jibx
- maven
- xfire
---
I uploaded on [Google code hosting](http://code.google.com/p/javaeesamples/ "Google code hosting")  an [example](http://javaeesamples.googlecode.com/files/wsbinding.tar.gz "wsbinding") of Webservices with Xfire (1.2.1) and Jibx (1.1) built with Maven2. Services are defined and accessed through a Spring application context.Have a look if you are interested in such a solution. The built server war file is for Weblogic server 8.1 but you should be able to run it in any servlet engine (>2.3).Where does Xfire and Jibx combination shine ?- When you need to adapt XML schemas to your Java model.  Let's say your client provides you the XML schemas that define the contract of your Webservice and you need to adapt them to your buisness interfaces.  Generally, business facades are not exposed directly as Webservices and an adapter layer is coded on top of it. The goal of the adapter layer is to transform simple types (arrays, primitive types, simplified objects) to more complex ones (the ones of your business interface).  Here with Jibx you can code transformation directly in the mapping file. The WSDL is still dynamically generated. This "design by contract" approach could also be used.
- Performance. Jibx is supposed to be efficient since it uses a stax XML parser to perform unmarshalling and instantiate your Java objects. But unfortunately I didn't run any benchmark to confirm this and compare Jibx XML binding with other binding libraries (JAXB 2, XMLBeans, Castor, etc.)
