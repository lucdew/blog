--- 
layout: post
title: htmlunit kudos
wordpress_id: 236
wordpress_url: http://www.dewavrin.info/?p=236
comments: true
categories: 
- java
- tech
tags: 
- htmlunit
- java
- xpath
---
I have been happily surprised by htmlunit. Actually, for a personal project, rewriting a rails app to Seam I tried to find a replacement of excellent Ruby library [hpricot](http://code.whytheluckystiff.net/hpricot/ "Hpricot"). I needed to perform Xpath expression on a HTML DOM tree to retrieve nodes.Well, htmlunit combined with Neko html parser and jaxen Xpath excels at just doing that. Htmlunit is also used by Canoo web testing .Here's a code snippet to retrieve all USA states on Yahoo Weather :

{% codeblock lang:java %}
final WebClient webClient = new WebClient();
final HtmlPage page = (HtmlPage) webClient.getPage("http://weather.yahoo.com/regional/USXX.html");
HtmlUnitXPath xpath = new HtmlUnitXPath("//div[@class='clearfix' and @id='browse']/ul/li/a");
List nodes = (List)xpath.selectNodes(page);
for (HtmlAnchor anchor: nodes) {       
   System.out.println(anchor.asText());
}
{% endcodeblock %}

Ok maybe htmlunit could reduce its dependencies and use Xpath support added to Java 5 (via Jaxp 1.3). But that's what i like about Java plateform: there's virtually a library for every need. And with (more or less) recent additions to the language: Generics, autoboxing, enums, DSL like code constructions (Fluent Interfaces) and future additions like closures, there are less and less reasons to use dynamically typed languages (even if i like Groovy).
