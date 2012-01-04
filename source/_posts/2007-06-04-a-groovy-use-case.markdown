--- 
layout: post
title: A groovy use case
wordpress_id: 228
wordpress_url: http://www.dewavrin.info/?p=228
comments: true
categories: 
- java
- tech
tags:
- groovy
- spring

---
I recently discovered Spring's ability to declare beans that are script-based. This feature can be used to mock business interfaces with Groovy implementations. In a JavaEE container where startup and redeployment can take a while, it can be very useful, in pre-integration tests, to change the behaviour of your business services especially without redeploying the whole EAR or restarting the server.Here's an example declaration:

{% codeblock lang:xml %}
<bean id="MockServiceImpl" class="org.springframework.scripting.groovy.GroovyScriptFactory">
  <constructor-arg value="${mocks.path}/MockServiceImpl.groovy"></constructor-arg>
</bean>
 
<bean class="org.springframework.scripting.support.ScriptFactoryPostProcessor">
  <property name="defaultRefreshCheckDelay" value="2"></property>
</bean>
{% endcodeblock %}

The "defaultRefreshCheckDelay" parameter sets the delay in seconds between checks for modifications of the script. and the groovy script:
{% codeblock lang:groovy %}
public class MockServiceImpl implements Service {
    ProductsReturn returnCase1 = new ProductsReturn(fetchDate:Calendar.getInstance(),products:[new Product(id:1,name:"good")])
    ProductsReturn emptyReturn = new ProductsReturn(fetchDate:Calendar.getInstance(),products:[])
 
    ReturnObject listProductsForUser(String userId) {
         return  returnCase1
    }
{% endcodeblock %}

I see many benefits in this solution:
- hot-swapping implementations without redeployment.
- returned objects can be dynamically generated. For instance if you want to return objects depending only one a given parameter it can be done easily.
- more concise than XML (see [xmlstubs](http://azote.sourceforge.net/xmlstubs.html) a XML based mocking solution).

On a side note, groovy requires ASM 2.2.2 library so if you use hibernate use the cglib with no dependency library which includes asm classes in renamed packages. Also use Spring 2.0.3+ if you use AspectJ pointcut declarations or you can expect errors.With maven profiles it 's easy to build a mock and non-mocked service layer of an EAR.Note that you can still inject the real implementations if you want to delegate work to it.
{% codeblock lang:xml %}
<bean id="MockServiceImpl" class="org.springframework.scripting.groovy.GroovyScriptFactory">
  <constructor-arg value="${mocks.path}/MockServiceImpl.groovy"/>
  <constructor-arg value="ServiceImpl"/>
</bean>
{% endcodeblock %}

On an other side note, I like both Groovy and JRuby but now tend to prefer Groovy because it leverages my knowledge of Java API. With Ruby i spend too much time finding the reference web site how to achieve things that i do almost naturally in Java. OTH, Ruby has its core API use closures. Closures are tightly integrated and tend to favor loose coupling.
