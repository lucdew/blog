--- 
layout: post
title: Weblogic impossible to load other JMX  classes
wordpress_id: 121
wordpress_url: http://www.dewavrin.info/?p=121
categories: 
- weblogic
tags: []

---
I have recently discovered that it not possible to use other JMX classes  (JMX 1.1 javax.management.*)than the ones in the weblogic.jar on Weblogic 8.1. 
Actually, I was trying to extend CruiseControl web app to offer the ability to start/resume/pauseintegration processes in the cruisecontrol daemon. The CruiseControl daemon has its own mx4j JMX agent with an embedded RMI connector (and an HTML adaptor which I didn't want to use). My webapp connects to the RMI adapator to contact the MBean server of cruisecontrol. 

But I had class cast exceptions when run inside Weblogic on the JMX classes. I tried to use the mx4j JMX classes but actually there is no way to do it. I tried to add them in the Weblogic server's classpath before the weblogic.jar but Weblogic refuses to boot. So I added them in the WEB-INF/lib directory of my web app and used the special option <prefer-web-inf-classes> in the weblogic.xml file but it didn't work either. This option is supposed to force the Webapp classloader to first load the classes in the WEB-INF subdirectories lib and classes contrary to the hierarchical classloading mecanism. But fatally, it doesn't work for javax.management.* classes and it's not documented. The reason given me by the BEA support is that the javax.management.* classes are already used internally even in the context of the web app classloader for monitoring purpose...  
</prefer-web-inf-classes>
