--- 
layout: post
title: Create your own @Logger annotation
wordpress_id: 233
wordpress_url: http://www.dewavrin.info/?p=233
categories: 
- java
- tech
tags:
- aspectj
- java

---
Some frameworks like Seam use the <span class="term"><tt class="literal">@Logger </tt></span>annotation to instantiate a logger. Seam discovers at deployment annotated classes  (see the [Scanner](http://viewvc.jboss.org/cgi-bin/viewvc.cgi/jboss/jboss-seam/src/main/org/jboss/seam/deployment/Scanner.java?revision=1.29&view=markup) class for instance).You could mimic this behaviour with Spring and its AOP capabilities on Spring beans with the &lt;aop:aspectj-autoproxy/&gt; feature.But if you don't want to bootstrap your application with an IOC  container or a framework, there's still AspectJ AOP to the rescue.For the example, let's create the Logger marker annotation (AspectJ requires the target retention to be set to RUNTIME).
{% codeblock lang:java %}
@Target({FIELD})
@Retention(RUNTIME)
@Documented

public @interface Logger {}
{% endcodeblock %}

Now in any class of your application, create a Logger (to make it short we'll use the commons-logging API and its org.apache.commons.logging.Log interface).Example:
{% codeblock lang:java %}
@Logger private org.apache.commons.logging.Log logger;
{% endcodeblock %}

Then the aspect with Aspectj annotated feature and a bunch of reflection to instantiate the logger appropriately (it only invokes the LogFactory and sets the proper class name).
{% codeblock lang:java %}
@Aspect
public class LoggerAspect {
 
  @Before("get(@Logger Log biz.dewavrin..*)")
  public void doSomething(JoinPoint thisJoinPoint) {
    System.out.println("ASPECT logger applied");
 
    Field[] fields = thisJoinPoint.getTarget().getClass().getFields();
    Class clazz = thisJoinPoint.getSignature().getDeclaringType();
 
    try {
      Field field = clazz.getDeclaredField(thisJoinPoint.getSignature().getName());
      field.setAccessible(true);
      if (null == field.get(thisJoinPoint.getTarget()) ) {
          field.set(thisJoinPoint.getTarget(), new KeyLogger(thisJoinPoint.getSignature().getDeclaringTypeName()));
      }
 
    } catch (Throwable t) {
        System.err.println("Warning aspect no applied on class="+thisJoinPoint.getTarget().getClass().getCanonicalName());
    }
  }
 
}
{% endcodeblock %}

The key here is the pointcut definition with a @Before advice and the get pointcut which intercepts accesses to every field annotated with @Logger annotations from a base package and its descendents.To build with maven, bind the maven's aspectj plugin compile goal to your compile phase:

{% codeblock lang:xml %}
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>aspectj-maven-plugin</artifactId>
  <configuration>
    <source>1.5</source>
    <target>1.5</target>
  </configuration>
  <executions>
    <execution>
       <phase>compile</phase>
      <goals>
        <goal>compile</goal>
      </goals>
    </execution>
  </executions>
</plugin>
{% endcodeblock %}
Note that the aspect could be packaged in a dedicated library and woven to your classes (see [aspects libraries](http://mojo.codehaus.org/aspectj-maven-plugin/libraryJars.html)) for usage example.

=&gt; Ok this example is only for demonstrative purpose and adds the overhead of reflection on every access to common's logging Log implementation getters !So it might not be a good idea after all due to performance penalty. But it's just a starting point for other annotations with aspects ideas to build your own framework.
