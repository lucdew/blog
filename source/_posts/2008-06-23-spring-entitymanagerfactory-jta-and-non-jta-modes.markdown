--- 
title: Spring entityManagerFactory in jta and non-jta modes
date: 2008-06-23
categories: 
- java
- general
- tech
tags: 
- jpa
- spring
permalink: spring-entitymanagerfactory-jta-and-non-jta-modes
---
This blog post is about using JPA with Spring in 2 contexts :
-  production with a JTA transaction manager
- testing with transactions handled by jpa transaction manager.
It has been inspired by [Erich Soomsam blog post](http://erich.soomsam.net/2007/04/24/spring-jpa-and-jta-with-hibernate-and-jotm/)You can achieve such configuration with a PersistenceUnitPostProcessor having a single persistence.xml file and 2 Spring context files (1 for each environment).Since you are likely to have at least 2 different Spring dataSource definitions : 1 for production that performs a JNDI lookup to find a bound datasource and 1 for development that uses a local and Spring declared datasource backed by a JDBC connection pool (C3p0 or DBCP), place the entityManager declaration in the same file as the datasource declaration. Let's say that the default persistence.xml use the non-jta datasource:
{% codeblock lang:xml %}
<persistence xmlns="http://java.sun.com/xml/ns/persistence"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemalocation="http://java.sun.com/xml/ns/persistence    http://java.sun.com/xml/ns/persistence/persistence_1_0.xsd"
	version="1.0">
	<persistence-unit transaction-type="RESOURCE_LOCAL"
		name="seamphony">
		<properties>     <!-- Scan for annotated classes and Hibernate mapping XML files -->
			<property value="class, hbm" name="hibernate.archive.autodetection" />
			<property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect" />
		</properties>
	</persistence-unit>
</persistence>
{% endcodeblock %}
Here's how you can use Spring to post process the persistence unit and configure it for production (here with MySQL datasource and JBoss Transaction Manager):
{% codeblock lang:xml %}
<bean
	class="org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean"
	id="entityManagerFactory">
	<property ref="dataSource" name="dataSource"></property>
	<property name="jpaVendorAdapter">
		<bean class="org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter">
			<property value="MYSQL" name="database" />
			<property value="true" name="showSql" />
			<property value="org.hibernate.dialect.MySQLDialect" name="databasePlatform" />
		</bean>
	</property>
	<property name="jpaPropertyMap" />
</bean>
<map>
	<entry value="org.hibernate.transaction.JBossTransactionManagerLookup"
		key="hibernate.transaction.manager_lookup_class">
		<entry value="true" key="hibernate.transaction.flush_before_completion" />
		<entry value="true" key="hibernate.transaction.auto_close_session" />
		<entry value="jta" key="hibernate.current_session_context_class" />
		<entry value="auto" key="hibernate.connection.release_mode" />
	</entry>
</map>
<property name="persistenceUnitPostProcessors">
	<list>
		<bean class="JtaPersistenceUnitPostProcessor">
			<property value="true" name="jtaMode"></property>
			<property ref="dataSource" name="jtaDataSource"></property>
		</bean>
	</list>
</property><!-- Datasource Lookup -->
<bean class="org.springframework.jndi.JndiObjectFactoryBean" id="dataSource">
	<property name="resourceRef">
		<value>false</value>
	</property>
	<property name="jndiName">
		<value>java:/MyDS</value>
	</property>
</bean><!-- Transaction Manager -->
<bean class="org.springframework.transaction.jta.JtaTransactionManager"
	id="transactionManager">
	<property value="java:/TransactionManager" name="transactionManagerName" />
	<property value="false" name="autodetectUserTransaction" />
</bean>
{% endcodeblock %}

Here's the class that reads the jta mode property and configure the transaction type accordingly:
{% codeblock lang:java %}
import javax.persistence.spi.PersistenceUnitTransactionType;
import javax.sql.DataSource;
import org.springframework.orm.jpa.persistenceunit.MutablePersistenceUnitInfo;

import org.springframework.orm.jpa.persistenceunit.PersistenceUnitPostProcessor;

public class JtaPersistenceUnitPostProcessor implements
		PersistenceUnitPostProcessor {
	private boolean jtaMode = false;
	private DataSource jtaDataSource;
	private PersistenceUnitTransactionType transacType = PersistenceUnitTransactionType.RESOURCE_LOCAL;

	public void postProcessPersistenceUnitInfo(
			MutablePersistenceUnitInfo mutablePersistenceUnitInfo) {
		if (jtaMode) {
			transacType = PersistenceUnitTransactionType.JTA;
			mutablePersistenceUnitInfo
					.setJtaDataSource(this.getJtaDataSource());
		}
		mutablePersistenceUnitInfo.setTransactionType(transacType);
	}

	public boolean isJtaMode() {
		return jtaMode;
	}

	public void setJtaMode(boolean jtaMode) {
		this.jtaMode = jtaMode;
	}

	public DataSource getJtaDataSource() {
		return jtaDataSource;
	}

	public void setJtaDataSource(DataSource jtaDataSource) {
		this.jtaDataSource = jtaDataSource;
	}
}

{% endcodeblock %}

Spring really helps tuning your persistence unit for different environments. It could be achieved by a custom build task that could alter the persistence.xml file but since this example assumes that Spring is already used, it can be avoided.
