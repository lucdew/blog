--- 
layout: post
title: Stat your commits
wordpress_id: 245
wordpress_url: http://www.dewavrin.info/?p=245
categories: 
- java
- tech
tags: 
- maven
- subversion
---
I recently discover the [StatSCM](http://stat-scm.sourceforge.net/) maven plugin and it made our team day . It gives useful information about your Subversion activity (it supports other SCM systems) giving precise developers activity information or file statistics. It also generates some nice charts. I found it very useful to monitor what the team members commit: for instance we discovered that a trainee was the developer of the month (ranked by LOC commited) because he commited some very large csv test files.First to enable it, configure the dependency and declare the report in the reports section of your maven parent pom file:
{% codeblock lang:xml %}
<pom>
	<build>
		<plugins>
			<plugin>
				<groupid>net.sf</groupid>
				<artifactid>stat-scm</artifactid>
				<dependencies>
					<dependency>
						<groupid>net.sf</groupid>
						<artifactid>stat-svn</artifactid>
						<version>0.4.0-StatSCM</version>
					</dependency>
					<dependency>
						<groupid>org.apache.maven.reporting</groupid>
						<artifactid>maven-reporting-impl</artifactid>
						<version>2.0.4</version>
					</dependency>
				</dependencies>
			</plugin>
		</plugins>
	</build>
	<reporting>
		<plugins>
			<plugin>
				<groupid>net.sf</groupid>
				<artifactid>stat-scm</artifactid>
				<configuration>
					<excludes>
						<exclude>**/*.csv</exclude>
					</excludes>
				</configuration>
			</plugin>
		</plugins>
	</reporting>
</pom>	
{% endcodeblock %}
And here some charts produced, like the number of LOC commited by each developer:[![Number of lines of code](http://www.dewavrin.info/resources/loc.png "Number of lines of code")](http://www.dewavrin.info/resources/loc.png)The  day commit activity:[![Commits activity](http://www.dewavrin.info/resources/commitsactivity.png "Commits activity")](http://www.dewavrin.info/resources/commitsactivity.png)Or the ration between files addition/modification:[![](http://www.dewavrin.info/resources/activity.png)](http://www.dewavrin.info/resources/activity.png)