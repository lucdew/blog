--- 
layout: post
title: Tomcat Active Directory realm
wordpress_id: 204
wordpress_url: http://www.dewavrin.info/?p=204
comments: true
categories: 
- java
tags:
- tomcat

---
 Even if configuring a JNDI realm for Tomcat is pretty well documented connecting Tomcat to Active Directory is not really.

After [my post](http://www.jroller.com/page/ldewavrin/20041129) about Weblogic and active directory authentication and authorizations.

Here's a just an example of a configuration of the JNDI realm for ADS in order to use the container 's authentication and authorization features.It might help some...

{% codeblock lang:xml %}
<realm classname="org.apache.catalina.realm.JNDIRealm" 
       debug="99" connectionurl="ldap://directory:389"
       connectionname="CN=manager,CN=Users,DC=mydomain,DC=net"
       connectionpassword="helloworld"
       userbase="OU=US_USERS,O=US,DC=mydomain,DC=net"
       usersearch="(&amp;(sAMAccountName={0})(objectclass=user))"
       rolebase="OU=US_GROUPS,OU=US,DC=mydomain,DC=net"
       usersubtree="true"
       rolename="cn"
       rolesubtree="true"
       rolesearch="(&amp;(member={0})(objectclass=group))" />
{% endcodeblock %}

Notes:
- By default with ADS, it seems that anonymous read of LDAP entries is forbidden. So you need to provide a "connectionName" with its password to enable the retrieval of users and roles.
-  Since the configuration of the JNDI realm is done in the server.xml file the &amp; character used in LDAP filters must be escaped by using its entity
- Roles are directly mapped to users with the role search filter where {0} is the Distinguished Name of eachuser (retrieved with the usersearch filter). It doesn't seem that like in Weblogic you can map roles to principalsin a JEE application server's specific Deployment Descriptor.

In the next post, I'll show how to access the realm from your webapp in order to use your own home made authentication and authorization frameworkwhile leveraging at the same time the Tomcat JNDI's realm.
