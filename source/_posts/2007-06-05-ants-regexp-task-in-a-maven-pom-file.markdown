--- 
layout: post
title: Ant's replaceregexp task in a maven pom file
wordpress_id: 229
wordpress_url: http://www.dewavrin.info/?p=229
categories: 
- java
- tech
tags: []

---
Since it can be tricky, here's how Ant's regexp task can be used in a maven pom file:<pre line="1" lang="xml"><plugin>  <artifactid>maven-antrun-plugin</artifactid>  <executions>    <execution>      <phase>compile</phase>      <configuration>        <tasks>          <echo>Online uncomment of ${basedir}/src/main/resources/beanRefContext.xml</echo>          <copy>              file="${basedir}/src/main/resources/beanRefContext.xml"              todir="${basedir}/target/classes" /&gt;          <replaceregexp>              file="${basedir}/target/classes/beanRefContext.xml"              match="&lt;!--s*(&lt;[^-{2}]+)--&gt;" replace="1"              byline="true" /&gt;        </replaceregexp>          </copy>        </tasks>      </configuration>      <goals>        <goal>run</goal>      </goals>    </execution>  </executions>  <dependencies>    <dependency>      <groupid>ant</groupid>      <artifactid>ant-nodeps</artifactid>      <version>1.6.5</version>    </dependency>    <dependency>      <groupid>ant</groupid>      <artifactid>ant-apache-regexp</artifactid>      <version>1.6.5</version>    </dependency>    <dependency>      <artifactid>jakarta-regexp</artifactid>      <groupid>jakarta-regexp</groupid>      <version>1.4</version>    </dependency>  </dependencies></plugin></pre>
