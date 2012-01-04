--- 
layout: post
title: Proxying Weblogic SNMP Agent
wordpress_id: 125
wordpress_url: http://www.dewavrin.info/?p=125
comments: true
categories: 
- weblogic
tags:
- weblogic
- snmp

---
 Today many middleware and back end enterprise systems embedtheir own SNMP agent (or at least send SNMP traps). SNMP agentsare polled by SNMP managers or enterprise monitoring systems likeTivoli Netview or HP Openview.

[Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") offers the ablity to proxy the OS SNMP agent and other SNMP agents butgenerally it's better to use the OS's SNMP agent asa proxy for all applications SNMP agents hosted on your machine.(Mostly because if the OS SNMP agent fails it's likely that the machine isdown and all its applications also ;-) whereas if [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") SNMP agent fails the OSmight still be alive).

In order to achieve this goal on Linux/Unix, you can use the [net-snmp](http://www.net-snmp.org/)(a.k.a ucd-snmp) to proxy SNMP requests to [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server's SNMP agent.And it's pretty straightforward.

The [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") domain is composed here of 2 [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") servers one administrationserver adminserver and 1 managed server ejbserver on the hostname machine. The [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") SNMP agent runs on port1610 of the administration server and is allowed to received requests and send traps for the weblogicpublic community.

Here's the [net-snmp snmpd.conf](http://www.net-snmp.org/docs/man/snmpd.conf.html) I used:

{% codeblock %}
syslocation  "SunOS hostname 5.8 Generic_108528-16 sun4u sparc SUNW,Sun-Fire-480R"
syscontact  "Root "
rocommunity public
rocommunity weblogicpublic
rouser myuser noauth
proxy -v 1 -c weblogicpublic hostname:1610 .1.3.6.1.4.1.140
proxy -Cn adminserver -v 1 -c weblogicpublic@adminserver hostname:1610 .1.3.6.1.4.1.140
proxy -Cn ejbserver -v 1 -c weblogicpublic@ejbserver hostname:1610 .1.3.6.1.4.1.140
{% endcodeblock %}

Line 4: we authorize the weblogicpublic community to perform SNMP polling requests.

Line 6: by default SNMP requests are forwarded to [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") SNMP agent without context for all requests that concern the [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server MIB (starting with .1.3.6.1.4.1.140 OID)

Line 7: a context is configured to address the adminserver [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server

Line 8: same as above for the ejbserverDon't forget to add the [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues")'s MIB in the net-snmp MIB repository and you're done.
