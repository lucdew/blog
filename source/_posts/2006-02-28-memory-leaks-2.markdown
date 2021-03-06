--- 
layout: post
date: 2006-02-28
title: Memory leaks
wordpress_id: 196
wordpress_url: http://www.dewavrin.info/?p=196
comments: true
categories: 
- java
tags:
- java


permalink: memory-leaks-2
---
 Crazy Bob posted on [ThreadLocal memory leaks](http://crazybob.org/2006/02/threadlocal-memory-leak.html).This type of memory leak really annoys me because I see it very often on Java EE servers and developers are not aware of it.The error is mostly annoying in development, testing environmentswhere the Java EE server is not restarted and the applicationsare just redeployed. Therefore, threads (of thread pools) are not recreated and hold references to old application classes.

My advice is **CLEAN YOUR THREADLOCALs**

Add a servlet filter, Web frameworkinterceptor or WS handler to set all ThreadLocal variables to null just beforereturning the response to the client. Lower level solutions should be preferred and turn out to be less risky. A dummy implementation (to give an idea) would be a servlet filter:
{% codeblock lang:java %}
public class ContextCleanerFilter implements Filter {
 
	private ContextCleaner ctxCleaner;
 
	public void init(FilterConfig filterConfig) {
	    // CtxCleaner instantiated directly boooh !!!
		ctxCleaner = new StaticContextCleaner();
	 }
 
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException  {
 
	    // Reset ThreadLocals before processing the request
		if (ctxCleaner != null) ctxCleaner.cleanAll();
		chain.doFilter(request,response);
		// Reset ThreadLocals after processing the request
		if (ctxCleaner != null) ctxCleaner.cleanAll();
	}
 
	public void destroy() {
 
	}
 
}
{% endcodeblock %}

with a ContextCleaner Interface:
{% codeblock lang:java %}
public interface ContextCleaner {
   boolean cleanAll();
}
{% endcodeblock %}

and a dummy implementation:
{% codeblock lang:java %}
public class StaticContextCleaner implements ContextCleaner {
 
	public boolean cleanAll() {
	   UserSession.setSessionData(null);
	   return true;
	}
 
}
{% endcodeblock %}

Where UserSession has static accessors to handle the ThreadLocal and is used by application code to store objects in a ThreadLocal instance:
{% codeblock lang:java %}
public class UserSession {
	private static ThreadLocal m_session= new ThreadLocal();
	public static void setSessionData(SessionData sessionData){
		m_session.set(sessionData);
	}
	public static SessionData getSessionData(){
		return (SessionData)m_session.get();
	}
}
{% endcodeblock %}

The problem with this implementation is that it only works with classes that you controland are aware that they use ThreadLocal variables. Maybe with reflection it's possible to accessthe current Thread's Map which stores ThreadLocal objects and set them to null one by one. But it would be highly risky if your application server uses ThreadLocal for its own usage.

For further information on ThreadLocal memory leaks see [this link](http://blog.arendsen.net/?p=18)
