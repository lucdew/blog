---
title: "Some Maven tips"
date: "2009-02-07" 
categories: [ "java","tech" ]
tags: ["maven"]
permalink: some-maven-tips
---

First post of the year, here are some Maven tips you might find useful (or obvious for experienced users):

* **How to version commercial libraries in your SCM and use them as dependency ?**

In case you don't have your own central repository and you'd like to version your libraries in your SCM server, you can declare in your pom a repository like this :
{% code lang:xml %}
<repository>
    <id>sipphonyrepo</id>
    <url>file:///${basedir}/../repository</url>
</repository>
{% endcode %}
The 'repository' directory should be versioned in your scm server but it also means that it should be checked out with your project. Also like any other repository, the dependencies will be copied in your local repository.

*  **How to just copy files** ?

It might be useful on a development machine to copy files while installing an artifact, for instance you might want to copy a JBoss datasource file to a JBoss profile to make sure it's deployed.  For this you can use the Maven resource plugins. For instance the following plugin statement will copy the datasource file to your JBoss server's default profile deployment directory if JBOSS_HOME environment library is defined (on the development machine) :
{% code lang:xml %}
<profile>
 <id>jboss.deploy</id>
 <activation>
  <property>
     <name>env.JBOSS_HOME</name>
  </property>
 </activation>
 <build>
    <plugins>
       <plugin>
         <artifactid>maven-resources-plugin</artifactid>
         <version>2.3</version>
         <executions>
           <execution>
             <id>copy-ds</id>
             <goals>
               <goal>copy-resources</goal>
             </goals>
             <phase>install</phase>
             <configuration>
                <outputdirectory>${env.JBOSS_HOME}/server/default/deploy</outputdirectory>
                <resources>
                  <resource>
                   <directory>${basedir}</directory>
                   <includes>
                      <include>mysql-ds.xml</include>
                  </includes>
               </resource>
               </resources>
             </configuration>
           </execution>
         </executions>
      </plugin>
    </plugins>
  </build>
</profile>
{% endcode %}

* **How to perform complex build build logic ?**

One solution would be to use profiles for that like in the above example. But it can quickly become cumbersome and limited. So a good option is to use Ant Maven plugin with [ant-contribs](http://ant-contrib.sourceforge.net/) dependency for control statements and loops or even better the [groovy GMaven plugin](http://groovy.codehaus.org/GMaven) (avoiding XML verbosity).Profiles have still the benefit of clearly identifying an intent in your build. The following command will list all profiles:

{% code lang:bash %}
mvn help:all-profiles
{% endcode %} 

If build logic can be extracted and used in different contexts, it's time to create a plugin. It's quite simple.

* **How to create an artifact of a zip or tar  ?**

One obvious solution is to use maven assembly plugin but if you need to add some custom logic during packaging, you could just create the zip or tar file with Ant maven plugin or groovy GMaven plugin and gant during the package phase. Then attach the file to your project with Maven [build helper plugin](http://mojo.codehaus.org/build-helper-maven-plugin/attach-artifact-mojo.html) and its **attach-artifact** goal to install it in your repository during the install phase. Once installed in your local repository, the zip or tar file can be become a dependency, just use the proper type in the dependency declaration.
{% code lang:xml %}
<type>zip</type>
{% endcode %}

* **How to create a full delivery layout with multiple archetype ?**

My advice for creating a comprehensive delivery directory structure would be to use a dedicated module, take advantage of ant,assembly and resource plugins for that. Struts2 has such a module : [see the assembly module's pom](http://svn.apache.org/repos/asf/struts/struts2/trunk/assembly/pom.xml)
