--- 
layout: post
title: Spring AOP and MVC authorization
wordpress_id: 193
wordpress_url: http://www.dewavrin.info/?p=193
comments: true
categories: 
- java
tags: 
- aop
- aspectj
- spring
---
With Spring and a bunch of AOP I'll show how it's easy to add protectionsof your business components and notify the view that the user is not authorizedto perform a specific action.This example relies on Spring 2.0 and Spring MVC for the presentation layer.Let's take an example of a service that executes jobs whose class is named JobExecutorService.This service has methods to add jobs in a Job queue, remove a job from the queueor stop a running job. We would like to authorize only owners of a job to remove the job or stop it. The jobs are persistent (to recover from failure).

<u>1) Defining the authorization aspect</u>
Let's define in Spring's application context a Job authorization advice and inject it a Job DAO to access persistent jobs.
{% codeblock lang:xml %}
<bean id="jobAuthorizationAspect" class="security.JobAuthorizationAspect">
	<property name="jobDAO">
		<ref bean="jobDAO" />
	</property>
</bean>
{% endcodeblock %}
Here's below the simplified code of the bean advice which is just a POJOwhich benefits from injection.When the user doesn't own the Job an AuthorizationException is thrown.We'll see later how to deal with the exception.
{% codeblock lang:java %}
public class JobAuthorizationAspect {
 
JobDAO jobDAO;
protected static final Log LOG =LogFactory.getLog(JobAuthorizationAspect.class);
 
public void setJobDAO(JobDAO jobDAO) {
this.jobDAO= jobDAO;
}
public void checkForAuthorization(Job job) {
boolean authorized = false;
 
UserContext userCtx = ContextMgr.getUserContext();
 
if (null != userCtx) {
Job job = jobDAO.getJobById(job.getId());
// If user launched Job, he's allowed to perform operations on it
if ((job.getState() == Job.STATE.RUNNING || job.getState() == Job.STATE.STOPPED || job.getState() == job.getState().ENDED) && job.getOwner().equals(userCtx.getPrincipal().getName())) authorized =true;
}
}
else {
LOG.warn("user context or job context have not been found");
}
if (! authorized ) {
LOG.warn("user not authorized");
throw new AuthorizationException("jobaction.notauthorized",new Object[]{},"this action is not allowed");
}
}
{% endcodeblock %}
<u>N.B</u>
I used Spring to bind user's context (which stores user information) to the current Thread via a ThreadLocal to easily retrieve user's data stored in memory and avoid being tied to the Servlet API. ContextMgr classhas a static method to retrieve user's context.Actually binding is done with a Spring MVC interceptor on controllers in the Spring Web Application Context(you could also use a Servlet filter):
{% codeblock lang:xml %}
<bean id="authurlMapping"
class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping">
   <property name="mappings">
      <props>
      <prop key="/jobs.htm">JobMultiActionController</prop>
         <!-- Add additional URL mappings here -->
      </props>
   </property>
   <property name="interceptors">
   <list>
      <ref bean="ContextInterceptor"/>
   </list>
   </property>
</bean>
{% endcodeblock %}

The ContextInterceptor bean just retrieves user’s data from the HTTP session
and binds it to the current thread

<u>2) Declaring the poincuts</u>

Then we add pointcuts to execute the aspect. Here the pointcuts are defined with AspectJ expressions
{% codeblock lang:xml %}
<aop:config proxyTargetClass="true">
<aop:aspect id="beforeAdviceJobAuth" ref="jobAuthorizationAspect">
<aop:advice
kind="before"
method="checkForAuthorization" arg-names="job"
pointcut="(execution(* jobqueue.JobExecutorService.stopJob(..)) and args (job)) || ( execution(* jobqueue.JobExecutorService.removeJob(..)) and args(job)) "/>
</aop:aspect>
</aop:config>
{% endcodeblock %}


So here we are weaving our jobAuthorizationAspect advice with the JobExecutorService bean (not detailed here).The proxyTargetClass attribute is here because the JobExecutorService is declared elsewehere in Spring's applicationContext and injected and used directly in Spring MVC controllers not via its interfaces. But the bean's class implements multiple interfaces (infrastructure interfaces like Observer )Spring's default behaviour is when it detects that the class implements interfaces it to use Java dynamic proxies. So here we set this attribute to force CGLib proxying.The arg-names attribute is here to be as explicit as possible and make sure that our "before" advice is executed for the proper methods of JobExecutorService and that the Job argument is passed (by reference) to the "checkForAuthorization" method of our advice.

<u>3) Dealing with the AuthorizationException</u>

Spring has a mechanism that allows to intercept exceptions and deal with them.We could catch the error and redirects to a page displaying a generic authorization message,we'll choose to extend this concept to return to the submitting view to display the message.Here's the declaration of the AuthorizedExceptionResolver
{% codeblock lang:xml %}
<bean id="AuthorizedExceptionResolver" class="web.AuthorizedExceptionResolver">
  <property name="order"><value>1</value></property>
</bean>
{% endcodeblock %}

And a simplified version of the code (we'll suppose that all our controllersare SimpleFormController ). :
{% codeblock lang:java %}
public class RecoverableExceptionResolver implements HandlerExceptionResolver,Ordered,ApplicationContextAware {
 
private int order;
 
public ModelAndView resolveException(HttpServletRequest request,HttpServletResponse response,Object handler,Exception e) {
 
if (e instanceof RecoverableException ) {
 
Map<Object,Object> messages = new HashMap<Object,Object>();
if (handler != null && handler instanceof AbstractController ) {
   AbstractController controller = (AbstractController)handler;
   messages.put("errormessage",controller.getApplicationContext().getMessage(((AuthorizedException)e).getMessageKey(),"not authorized",((AuthorizedException)e).getMessage(),request.getLocale()));
request.setAttribute("messages",messages);
}
 
// If SimpleFormController return internally to its view
if (null != handler && handler instanceof SimpleFormController) {
return new ModelAndView(controller.getFormView());
}
}
 
return null;
}
 
public int getOrder() {
return order;
}
 
public void setOrder(int order) {
this.order = order;
}
 
}

{% endcodeblock %}
Here I made the assumption that the command (object that maps the HTTP submitted parameters)has been bound to user's session in the controller (Spring has mechanism to do this)and that the form's view first check that if the form's command is in the user's sessionit uses it to populate the form's fields.We'll also suppose that the controller's form view has a box that displays messages whenfound in the request context under the messages attribute (like flash boxes of ROR).

<u>Conclusion:</u>
AOP is the perfect tool to protect business components in a non-intrusive way.Thanks to Spring MVC framework techniques we can create a very flexible and genericway to handle authorizations and report authorization exceptions in our web layer. (using many of the Java EE cool buzz technos)

_N.B:_ Sorry for my poor English...
