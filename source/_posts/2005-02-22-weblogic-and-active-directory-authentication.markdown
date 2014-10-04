--- 
layout: post
date: 2005-02-22
title: Weblogic and Active Directory authentication
wordpress_id: 126
wordpress_url: http://www.dewavrin.info/?p=126
comments: true
categories: 
- weblogic
tags:
- weblogic
- ldap

permalink: weblogic-and-active-directory-authentication
---
Ok back to more serious [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") posts !

Intranet web applications often require to authenticate users with their Windows domain account.[Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") can be easily configured to authenticate users through ActiveDirectory Server. [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") connects to ADS with LDAP (protocol) andtries to bind to the latter with user's credentials.

To do so, it's pretty easy,just create in your security realm an "Active Directory Authenticator".

You need an account which will have sufficient rights to browse the LDAP's Directory InformationTree of ADS to retrieve users and groups. Also you need to configure ADS to authorize LDAPrequests: bind,read and lookups at least on the branches where users and groups reside (this seems to be enabled by default once connected as domain user).

When a user will connect to your Web application and be asked for login/password, the following steps will be performed by the authenticator:
- Retrieve the Distinguished Name of the user by performing a LDAP request to ADS.The search's filter and base DN can be configured in the users tab of the authenticator in the administration console. Also in that tab you can specify theuser's attribute name with which the filter to get the user DN will be applied.
- Then [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") binds to ADS with the distinguished name and password given.
- If previous step is successful, then it tries to find out to which groups the userbelongs. For this, the filter defined in the membership tab (when configuring the authenticator)is used on each static group. Then in the "autentication and authorization" process the other security providers ( authorization and role mapper)are invoked.

As you might have noticed, LDAP requests are numerous and it's a good idea toenable the cache of LDAP lookups. The cache has a TTL but there's no option to reset the cache in the console. The AD authenticator MBean doesn't provide a method to reset the cache programmatically.Here's a sample configuration extracted from the config.xml file I used for a domain called snakeoil.com.Of course, you might have organised your users and groups differentlyand should adapt your base DN search and filter parameters.

{% codeblock lang:xml %}
<weblogic.security.providers.authentication.activedirectoryauthenticator 
ontrolflag="OPTIONAL" credential="{3DES}8KN5usC0Qp0qSVbgQqtHpg==" displayname="SNAKEOIL_ADS" 
groupbasedn="OU=SNAKEOIL_GLOBAL_GROUPS,OU=US,DC=snakeoil,DC=com" host="myhost" 
name="Security:Name=myrealmSNAKEOIL_ADS" principal="CN=FirstName 
LastName,OU=SNAKEOIL_USERS_INTERNALS,OU=SNAKEOIL_USERS,OU=US,DC=snakeoil,DC=com" realm="Security:Name=myrealm" 
userbasedn="OU=SNAKEOIL_USERS,OU=US,DC=snakeoil,DC=com" 
userfromnamefilter="(&amp;(sAMAccountName=%u)(objectclass=user))" 
usernameattribute="sAMAccountName">
</weblogic.security.providers.authentication.activedirectoryauthenticator>
{% endcodeblock %}

I didn't change the membership's default parameters (they were fine for my environment)that's why they don't appear here. The  SAMAccountName attribute which contains the Windows login Idis used to find the user DN.

**NB1:**
By default the JAAS flag of the default authenticator is "required" and you should change it to "Sufficient" or "Optional" otherwise your ADS users will be denied access to your application

**NB2:**
Their might be a way to transparently authenticate the user once it has an open session on Windows but I haven't investigated on that (maybe with Kerberos):Update 12/7/2004: I am answering to my ignorance: yes it exists it is NTLM protocol [link](http://www.luigidragone.com/networking/ntlm.html)But it seems that there's no easy way to use it with WLS. It must be better to proxy [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") with IIS or use SiteMinder.Update 22/02/2005: Since WLS 8.1 sp4 it's possible to get automatically authenticated with the Kerberos token obtained once logged in the Windows domain. More explanations on [edocs.bea.com](e-docs.bea.com/wls/docs81/secmanage/sso.html)

**Links:**
- edocs.bea.com documentation about [Configuring LDAP authenticators](http://e-docs.bea.com/wls/docs81/secmanage/providers.html#1172008)
- edocs.bea.com documentation about [Configuring Single Sign-On with Microsoft Clients](e-docs.bea.com/wls/docs81/secmanage/sso.html)
- [Microsoft Active Directory Server](http://www.microsoft.com/windowsserver2003/technologies/directory/activedirectory/default.mspx)
- [Jxplorer](http://pegacat.com/jxplorer/) an opensource GUI ldap client written in Java (I discovered itrecently I used to browse LDAP trees with [LDAP browser](http://www-unix.mcs.anl.gov/~gawor/ldap/)
- [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") Pro Magazine's [article](http://www.ftponline.com/weblogicpro/2004_09/magazine/columns/troubleshootersdiary/default_pf.aspx) on debugging LDAP authenticator
