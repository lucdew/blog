--- 
layout: post
title: Ant's replaceregexp task in a maven pom file
wordpress_id: 229
wordpress_url: http://www.dewavrin.info/?p=229
categories: 
- java
- tech
tags:
- ant

---
Since it can be tricky, here's how Ant's regexp task can be used in a maven pom file:
{% codeblock lang:xml %}
<plugin>
  <artifactId>maven-antrun-plugin</artifactId>
  <executions>
    <execution>
      <phase>compile</phase>
      <configuration>
        <tasks>
          <echo>Online uncomment of ${basedir}/src/main/resources/beanRefContext.xml</echo>
          <copy>
              file="${basedir}/src/main/resources/beanRefContext.xml"
              todir="${basedir}/target/classes" /&gt;
          <replaceregexp>
              file="${basedir}/target/classes/beanRefContext.xml"
              match="&lt;!--s*(&lt;[^-{2}]+)--&gt;" replace="1"
              byline="true" /&gt;
        </replaceregexp>
          </copy>
        </tasks>
      </configuration>
      <goals>
        <goal>run</goal>
      </goals>
    </execution>
  </executions>
  <dependencies>
    <dependency>
      <groupId>ant</groupId>
      <artifactId>ant-nodeps</artifactId>
      <version>1.6.5</version>
    </dependency>
    <dependency>
      <groupId>ant</groupId>
      <artifactId>ant-apache-regexp</artifactId>
      <version>1.6.5</version>
    </dependency>
    <dependency>
      <artifactId>jakarta-regexp</artifactId>
      <groupId>jakarta-regexp</groupId>
      <version>1.4</version>
    </dependency>
  </dependencies>
</plugin>
{% endcodeblock %}
