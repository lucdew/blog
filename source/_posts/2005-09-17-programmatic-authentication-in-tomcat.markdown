--- 
layout: post
date: 2005-09-17
title: Programmatic authentication in Tomcat
wordpress_id: 111
wordpress_url: http://www.dewavrin.info/?p=111
comments: true
categories: 
- java
tags:
- tomcat
- weblogic

permalink: programmatic-authentication-in-tomcat
---
 I had to programmatically authenticate a principal using the security realm defined in Tomcat. I needed to do so because I didn't want to reinvent the wheel. But in my case the J2EE container authorizations defined in the web.xml DD didn't fit well. I also had to programmatically verify that user belonged to a role and the realm API let you do that. The resources to which users were restricted are not URLs but actions and the authorizations are defined in a specific configuration file and not in the web.xml file. I didn't want to have a specific URI for each action.

With Weblogic server doing programmatic authentication it's pretty easy. Just use the following code

<pre lang="java">int retcode = ServletAuthentication.weak(username,password,session);</pre>

for WLS 8.1 and
<pre lang="java">int retcode =  ServletAuthentication.weak(username,password,request,response);</pre> for WLS 9

For Tomcat, i managed to "mimic" containter authentication but haven't fully been able to do it. It's possible through JMX to access the configured realm. For instance, use the following code to retrieve the realm through a local connection to the MBean server (using JSR 160). I left commented code to access the MBean server remotely.

{% codeblock lang:java %}
package com.xxx.integ2.tomcat;
 
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
import javax.management.MBeanServer;
import javax.management.MBeanServerFactory;
import javax.management.ObjectName;
import javax.management.remote.JMXServiceURL;
import javax.naming.Context;
 
import org.apache.catalina.Manager;
import org.apache.catalina.Realm;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
 
public class JMXHelper {
 
	public static final String SERVER_URL="service:jmx:rmi:///jndi/rmi://localhost:9004/jmxrmi";
	private transient final static Log LOG = LogFactory.getLog(JMXHelper.class);
 
	public static Realm getRealm() {
 
		try {
            JMXServiceURL url = new JMXServiceURL(SERVER_URL);
			Map environment = new HashMap();
			environment.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
			environment.put(Context.PROVIDER_URL, "rmi://"+url.getHost()+":"+url.getPort());
 
            //MBeanServerConnection connection = JMXConnectorFactory.connect(url,environment).getMBeanServerConnection() ;
 
            // Retrieve MBeanserver
            List mbeanServers = MBeanServerFactory.findMBeanServer(null);
 
            MBeanServer mBeanServer = null;
            if (mbeanServers != null &amp;&amp; mbeanServers.size() &gt; 0) {
            	mBeanServer =  (MBeanServer) mbeanServers.get(0);
            }
 
    	   	String objName = "Catalina:j2eeType=WebModule,name=//localhost/manager,J2EEApplication=none,J2EEServer=none";
    	   	ObjectName contextObjectName = new ObjectName(objName);
    	   	Object contextManager = mBeanServer.getAttribute(contextObjectName, "manager");
 
    	   	//Object contextManagedResource = connection.getAttribute(contextObjectName, "managedResource");
 
    	   	Manager manager = (Manager)contextManager;
    	   	Realm realm = manager.getContainer().getRealm();       	       	return realm;
 
		} catch (Exception e) {
 
	        LOG.error("A problem occured retrieving the security realm",e);
		} 
 
		return null;
 
	}
 
}
{% endcodeblock %}

I also had to add the following jar to the common.loader in  catalina.properties file
<pre lang="text">${catalina.home}/server/lib/*.jar</pre> to be able to load the catalina API in my webapp.

For remote access using the JVM's RMI connector of the JVM's internal MBean server, add the following options when starting the JVM:
<pre lang="text">-Dcom.sun.management.jmxremote.port=9004 (-Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.pass.file=${tomcat.home}/jmxremote.password -Dcom.sun.management.jmxremote.ssl=false</pre>

The only problem is that you only delegate authentication to the JNDI realm but you are not really authenticating the user to the container. It means that method getUserPrincipal from HTTPServletRequest (**request.getUserPrincipal()**) will return null. One way to check that a user is authenticated would be to store the principal in the user's session. Then write a servlet filter or Spring MVC 's interceptor checking that a principal is stored in the user's session and redirecting to a login page in case it's not.

Interesting resources:
- Portable J2EE security framework : [ACEGI security](acegisecurity.sourceforge.net/)
- [Weblogic programmatic authentication](http://weblogic.sys-con.com/read/48219.htm) (user/password and certificate authentication)
- [JMX and JSR 160 in Java 5](http://java.sun.com/j2se/1.5.0/docs/guide/jmx/index.html)
