--- 
layout: post
title: "Maven quick tip: adding a local dependency"
wordpress_id: 189
wordpress_url: http://www.dewavrin.info/?p=189
categories: 
- java
tags: []

---
Well after almost 6 months of silence, here's a maven quick tipif you need to add a dependency on a library without adding ityour local maven repository.Define the dependency scope as system and the path to your library:<pre lang="xml"><dependency><groupid>weblogic</groupid><artifactid>weblogic</artifactid><version>8.1.4</version><scope>system</scope><systempath>${weblogic.home}/server/lib/weblogic.jar</systempath></dependency></pre>Then, either declare the weblogic.home property  in your pom<pre lang="xml"><properties>      <weblogic.home>c:/bea/weblogic81</weblogic.home></properties></pre>or add it to your settings.xml file by adding it to a default profile:<pre lang="xml"><profile>     <id>dev</id>     <properties>        <weblogic.home>C:/bea/weblogic81</weblogic.home>     </properties></profile><activeprofiles>    <activeprofile>dev</activeprofile></activeprofiles></pre>I am not yet fully committed to maven but it really shines for kickstartingJ2EE projects with artifacts and easily downloadable dependencies libraries.
