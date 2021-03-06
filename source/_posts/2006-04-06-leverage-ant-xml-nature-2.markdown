--- 
layout: post
date: 2006-04-06
title: Leverage Ant XML nature
wordpress_id: 195
wordpress_url: http://www.dewavrin.info/?p=195
comments: true
categories: 
- general
tags: 
- ant
permalink: leverage-ant-xml-nature-2
---
I have been responsible at my current job position of the build of our JavaEE application. We had to build 3 different flavours of the same application. When I decided which build tool to use, I chose Ant since only Maven 1.0 had been released and I disliked writing logic in Jelly. If I had to choose today I'd probably go with Maven 2 because it becomes a standard for industrializing builds on Java and I have just found [a decent documentation](http://www.agilocity.com/roller/page/wrast?entry=better_builds_with_maven_2) on it...

Our main application is built as an EAR file and I had to support packaging for different application servers. We decided to externalize dependencies (&lt;dependencies&gt; element), compilation (&lt;javalibs&gt; element) and packaging information (&lt;application&gt; element) in an XML description file. Then with the help of a XSL file, we generate dynamically an Ant build file and execute it. We reused Ant &lt;fileset&gt; and &lt;zipfileset&gt; to describe location of files or directories.

In the generation of the EAR, we used sensitive default behaviours to minimize configuration. Here are a few:
- include dependencies (see  element below) in the EAR unless scope is set to compile and add them to the MANIFEST.MF of each Java module.
- add dependencies to the global CLASSPATH (there's a compilation CLASSPATH for each targeted application server also)
- include generated libraries in the EAR unless distinclude is set to false and add them to the MANIFEST.MF of each Java module. If generated libraries are scoped to a given Java EE module they are added in the WEB-INF/lib for a web module or are overlaid with the final EJB jar for EJB modules. Generated global libraries are also added to the global CLASSPATH for compilation.

The general strategy was to compile and build global (use by multiple Java EE modules) Jar files with the global Classpath and specific ones with the application server's CLASSPATH and global CLASSPATH. This way global Jar files were compiled once for all the application servers.

It had some limitations:
- We only supported Java EE modules of type web or ejb.
- Global compiled Jar files could not depend on a specifig Jar files.
- Compilation Classpath are not totally isolated for each Web module.

I like our approach since with a light XML description file we can now generate an EAR for many application servers. application.xml for the EAR and MANIFEST.MF for each Java modules are generated dynamically. Configuration is far less important than for a Maven's Pom.xml. Ok we lack transitive dependencies,  web site generations, synchronization with Eclipse but we didn't really need them.Here's how a build description file could look like:

{% codeblock lang:xml %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE project [
	<!ENTITY LIBDIR "../lib">
	<!ENTITY LIBDIR "../src">
]>
<project name="myapp" compilation="shared">
	<dependencies>
		<fileset dir="&amp;LIBDIR;/log4j/" includes="log4j-1.2.8.jar"/>
		<fileset dir="&amp;LIBDIR;/xml" includes="jdom.jar"/>
		<fileset dir="&amp;LIBDIR;/weblogic/8.1" includes="webservices.jar" scope="compile" target="weblogic"/>
	</dependencies>
	<javalibs source="1.4">
		<javaproject dir="&amp;SRCDIR;/infra/" includes="core/**" name="infra"/>
		<javaproject dir="&amp;SRCDIR;/ws" name="presentationws" module="presentationweb" target="weblogic"/>
		<javaproject dir="&amp;SRCDIR;/wsaxis" name="presentationwsaxis" module="presentationweb" target="websphere"/>
		<javaproject dir="&amp;SRCDIR;/wsclient" name="wsclient" distinclude="false">
			<fileset dir="&amp;SRCDIR;/wsclient/config" includes="client-config.wsdd"/>
		</javaproject>
		<javaproject dir="&amp;SRCDIR;/Application/WebClient/src" name="wsclient" distinclude="false" sign="true">
			<attribute name="Main-Class" value="wsclient.Main"/>
			<attribute name="Class-Path" value="commons-httpclient-3.0.jar commons-logging.jar jaxrpc.jar mail.jar saaj.jar wsdl4j.jar"/>
		</javaproject>
	</javalibs>
	<application target="weblogic" format="ear">
		<zipfileset prefix="sql" dir="&amp;SRCDIR;/db" includes="*.sql"/>
		<module name="presentationws" type="web" context="PresentationWeb">
			<zipfileset prefix="WEB-INF" dir="&amp;SRCDIR;/config/PresentationWeb" includes="web.xml,weblogic.xml"/>
		</module>
	</application>
	<application target="websphere" format="ear">
		<zipfileset prefix="sql" dir="&amp;SRCDIR;/db" includes="*.sql"/>
		<module name="presentationws" type="web" context="PresentationWeb">
			<zipfileset prefix="WEB-INF" dir="&amp;SRCDIR;/config/PresentationWeb" includes="web.xml,ibm*.xml"/>
		</module>
	</application>
</project>
{% endcodeblock %}
