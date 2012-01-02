--- 
layout: post
title: What i learnt today or my ignorance revealed to the world
wordpress_id: 231
wordpress_url: http://www.dewavrin.info/?p=231
categories: 
- java
- tech
tags:
- jta

---
First of all happy new year 2007.Hi,I just discoverd today that closing a JDBC connection obtained via a DataSourcein a JTA transaction does not trigger a rollback (if autocommit is set to false)of the underlying transaction.Actually i didn't understand the Hibernate's after_statement connection release mode which aggressively close the connection after each statement (even if the JTA has not been commited or rollbacked). It's even Hibernate's advised mode for a JTA transaction . But reading the JTA spec seems to confirm that: 

{% blockquote %}
When the application invokes the connection's close method, the resource adapter invalidates the connection object reference that was held bythe application and notifies the application server about the close. The transaction manager should invoke the XAResource.end method to disassociate the transaction from that connection.

The close notification allows the application server to perform any necessary cleanup work and to mark the physical XA connection as free for reuse, if connection pooling is in place.
{% endblockquote %}

So ok, the connection is just returned to the pool without impacting the current transaction. For Weblogic it seems that in XA emulation mode, the connection is still locked until the transaction completes or fails.I think it's a common misconception of a JDBC connection behavior (at least for me) in a JTA environment.
