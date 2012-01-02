--- 
layout: post
title: Persistent Quartz Jobs with Spring
wordpress_id: 201
wordpress_url: http://www.dewavrin.info/?p=201
categories: 
- java
tags:
- spring
- quartz

---
I developped a small web Spring MVC application for the company I work for that allowed with other things to schedule executions of Ant scripts (reinventing the wheel...)

[Quartz](http://www.opensymphony.com/quartz/) is the natural choice in the J2EE world to schedule tasks and allows to express the schedule time (or period) using a Unix CRON pattern. And also Quartz can persist schedule jobs to database.

A Quartz job has to implement the [Job](http://www.opensymphony.com/quartz/api/org/quartz/Job.html) interface and for persistant jobs the [StatefulJob](http://www.opensymphony.com/quartz/api/org/quartz/StatefulJob.html) interface. The jobs are scheduled using a [Scheduler ](http://www.opensymphony.com/quartz/api/org/quartz/Scheduler.html) implementation. Spring provides a Scheduler factory (org.springframework.scheduling.quartz.SchedulerFactoryBean) and here I'll show how to declare the declare a persistent scheduler in Spring's application context that will store jobs to database (and allow all CRUD operations).

Before that Quartz provide DDL scripts that create the necessary tables for many RDBMS, so you need to apply them on your database.

Let's declare below the Scheduler using Spring's factory (SchedulerFactoryBean). Note that the properties are set here for MySQL and some optimized versions of the declared classes exist for other RDBMS

Update: the job store class JobStoreTX handles transactions by itself. Sousing it with a Spring transactional proxy like I did was useless and the schedulertarget could have been used directly. Instead use the JobStoreCMT with a Spring JTAtransaction manager and a JTA aware datasource (see below). 

Quartz doc says:
{% blockquote %}
If you need Quartz to work along with other transactions (i.e. within a J2EE application server), then you should use JobStoreCMT - in which case Quartz will let the app server container manage the transactions.
{% endblockquote %} 

{% codeblock lang:xml %}
<bean id="schedulertarget" class="org.springframework.scheduling.quartz.SchedulerFactoryBean">
 <property name="quartzProperties">
	<props>
		<prop key="org.quartz.jobStore.class">org.quartz.impl.jdbcjobstore.JobStoreCMT</prop>
		<prop key="org.quartz.jobStore.driverDelegateClass">org.quartz.impl.jdbcjobstore.StdJDBCDelegate</prop>
		<prop key="org.quartz.jobStore.tablePrefix">QRTZ_</prop>
	</props>
 </property>
 <property name="dataSource"><ref bean="${datasource}"/></property>
</bean>
{% endcodeblock %}

Then make methods of the scheduler transactional with a JTA transaction manager.
{% codeblock lang:xml %}
<bean id="dataSource"
   class="org.springframework.jndi.JndiObjectFactoryBean">
     <property name="jndiName">
        <value>java:comp/env/jdbc/myds</value>
     </property>
</bean>
<bean id="transactionManager" class="org.springframework.transaction.jta.JtaTransactionManager">
	<property name="dataSource" ref="${datasource}"/>
</bean>
<bean id="scheduler" class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
	<property name="transactionManager" ref="transactionManager"/>
	<property name="target" ref="schedulertarget"/>
	<property name="transactionAttributes">
		<props>
			<prop key="*">PROPAGATION_REQUIRED</prop>
		</props>
	</property>
</bean>
{% endcodeblock %}

Then you can inject directly the scheduler to a Spring MVC controller and programmatically have it doing CRUD operations on Job schedules (or use a cleaner approach with a DAO),etc.
