--- 
title: A jBPM review
date: 2007-11-16
categories: 
- java
- tech
tags: 
- jBPM
permalink: a-jbpm-review
---
Here's a quick review of [jBPM](http://labs.jboss.com/jbossjbpm/) and some issues I experimented on a recent project.**jBPM features:**
- **A bare workflow engine** focused on persistence of a business process.
- **Graph oriented programming** with different kinds of nodes (wait,action,decision, tasks,etc.) . The graph is represented in XML format following the Jboss Process Definition Language format.
- **Persistence handled by Hibernate**.
- **An eclipse plugin to visually design the Business Process** and generate the jPDLsource file. It can also generate a web form to enable user interactions with the Business Process (task nodes).
- **BPEL support** and **integration with Jboss ESB**.
- **A web console with JSF components** that allows to find process instances, timers, execute tasks and deploy jBPDL processes.
The main drawbacks with jBPM are:
- **jBPM does not provide any connectors** for wait nodes (incoming events) or action nodes (interaction with external systems). You have to code them and use jBPM API for signalling a process instance that it should proceed execution. Also by default, a signal operation on a process instance is synchronous and blocks until it finds a  wait node or any node with async attribute set to true .
- **the Business Process can not be published as a web service**. You can pass  data to the buisness process storing variable in its execution context with the jBPM API.
- **No "business transaction" support**.
- **Documentation is not really up-to-date** and be prepared to spend time on the wiki and the forums For instance we experienced the following issues:
 - We didn't use the jBPM console and we spent some time trying to figure out how to start jBPM timers. Well, a JobScheduler had to be started behind the scene .
 - We had troubles with transaction management and integration with JTA transactions. This one was not jBPM's fault but we spent some time on it. jBPM JobScheduleService delete persisted timers when the business process ends. It does this before the commit of the transaction by registering a JTA's Synchronization instance on the current JTA Transaction.  Our jBPM Hibernate session was also handled by Spring and also registered a Synchronization instance that closed the Hibernate session before commit. Of course, it closed session before the JobScheduler  and made the JobScheduler  fail to delete timers. As a workaround, we had to use raw Hibernate SessionFactory to prevent this (it avoided Spring 's beforeCommit session closing):
{% codeblock %}
hibernate.transaction.factory_class=org.hibernate.transaction.JTATransactionFactory
hibernate.transaction.manager_lookup_class=org.hibernate.transaction.JBossTransactionManagerLookup
hibernate.current_session_context_class=org.hibernate.context.JTASessionContext
{% endcodeblock %}
and setting the following property of the LocalSessionFactoryBean:
{% codeblock lang:xml %}
<property value="false" name="exposeTransactionAwareSessionFactory"></property>
{% endcodeblock %}
Also, we used the [Spring jBPM module](https://springmodules.dev.java.net/) since our jBPM actions, decision handlers were implemented as Spring beans. Spring module offers workflow deployments features but we found little value in Spring modules  since it's quite easy to extend jBPM to look for Spring beans in a Spring context. The jBPM Spring module does not seem to be maintained anymore.So, jBPM is really a bare workflow engine and we hope it will offer tigher integration with Jboss ESB for connection with external systems and also more advanced features.Seam offers integration with jBPM : you can register a jBPM process definition as a Seam component, and let Seam deploy it.  Seam also provides some anotations to interact with a business process to share data (bijection) with it or start it in a Seam conversation. Seam's adoption will probably boost jBPM's usage, well at least i am looking forward to it.
