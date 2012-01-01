--- 
layout: post
title: Review of Weblogic scripting languages wlst (Jython based) vs wlsh ( WLS shell)
wordpress_id: 133
wordpress_url: http://www.dewavrin.info/?p=133
categories: 
- weblogic
tags: []

---

 Both are tools to programmatically and easily configure [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") domains and   servers. Why these tools?
  -  to automate [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") servers and domain creation for large scale production     environment. Configuring a [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") domain through the administration console     is tedious and slow in a multiserver environment.
  -  Repeat a complicated configuration from server to server.

Well, you could use Java and JMX or do some reverse engineeringon some [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") class (like domain creation) but it would reallybe a waste of time, when tools exist to make domain administration easier.

# wlst
##  Pros:
  -  Jython (Python Implementation in Java) based powerful Object Oriented scripting     language. You can create your own classes like creating a Security classes     to add a user,a group return all the users of a domain... 
- Offline capabilites to create and configure     domains.
    -  Has functions for [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") Workshop.
##  Cons:
   -  learning curve of Jython/Python for more advanced coding logic.( But I have to admit that Python     is easy to learn).
  - type conversion between Java and python which can be annoying example: objs  = jarray.array([appname,None,None],java.lang.Object). 
- Some MBeans are hidden.   Example: can not invoke methods on the DeployerRuntime MBean  like the invoke method.  Maybe authors want users to use the dedicated deployment functions like deploy()   undeploy() instead. 
  - Can only use a property file to pass parameters to the script (but you could     import the wlst jython module and process jython command line arguments the     traditionnal way)
    #   wlsh
##  Pros
 - Easy to learn very much like Unix SHELL.
   -  Aditionnal tools: provide a graphical MBean (and cli) explorer + a graphical     monitoring tool. 
  -  Can pass any kind   of parameter to the script from the command line.
    ##  Cons: 
  - Not officially supported  by BEA. Some bugs exist "it returns null when trying to get some MBean". But   the author said a new version will be released for [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server 9.
  -  Limited   scripting capabilities. Language is limited (with limited control structures) 
 To conclude, both are not really mature tools and have some light bugs but   they greatly help in [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") configuration tasks. I don't know if Websphere or Oracle9iAS have this kind of tool but they represent a great advantage for [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues"). Especially for ISVs who want to help clients to configure a [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") server to run their application  Both tools can also convert an existing domain   configuration (config.xml) to a script which is a very helpful feature. I think that   for advanced [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") administration scripting wlst looks better (I chose to use it now). On the other  side some features of wlsh like the MBean explorer, the graphical MBean attributes   monitoring are really great. Porting wlst to Groovy scripting language ( Java   based scripting language with a JSR) would also have been a great idea since   it would avoid to learn another language (i.e python) but just the syntax of   Groovy.
