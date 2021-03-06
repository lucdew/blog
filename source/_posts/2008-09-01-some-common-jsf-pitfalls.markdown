---
title: Some common JSF pitfalls
categories: 
- java
- tech
date: 2008-09-01
tags: 
- jsf
- seam
permalink: some-common-jsf-pitfalls
---

Well at least here' s a non exhaustive list of common jsf pitfalls, i felt into (some are variants of others) :
-  Using a converter in  a **_SelectOneMenu_** or **_SelectManyList_** components, be careful of type being applied. See [http://saloon.javaranch.com/cgi-bin/ubb/ultimatebb.cgi?ubb=get_topic&amp;f=82&amp;t=003594.](http://saloon.javaranch.com/cgi-bin/ubb/ultimatebb.cgi%3Fubb%3Dget_topic%26f%3D82%26t%3D003594+converter+getAsObject+never+called&hl=fr&ct=clnk&cd=1&gl=fr) Using an array instead of typed collection for the component input values ( still not sure why, have investigated too much on it, so i won't extend on it)!
-  Declare a resource bundle in the page ( most of the time bundles are declared in a template page) with the **_loadbundle_** element instead of declaring it the faces-config.xml file . If done so, **_requiredMessage_** or **_converterMessage_** attibutes that can be applied to many UIInput components won't work (i.e the message won't be found).
- With a **_commandLink_** inside dataTables with a bean of request scope actions are not executed. At least it happened to me with JSF RI 1.2_07 and <span class="Apple-style-span" style="text-decoration: line-through">is due to the fact that the id of the dataTable component is changed between the component tree creation (restore view phase) and the render response phase </span><span style="color: red">( Update 09/21/2008 : See more explanations on this in the comment section by Dan Allen himself, author of "Seam in Action" )</span>. When submitted on a post back request, the actions event are not queues (passed as hidden fields). It's well detailled here [http://typo.ars-subtilior.com/articles/2007/02/07/jsf-datatable-and-commandlink. ](http://typo.ars-subtilior.com/articles/2007/02/07/jsf-datatable-and-commandlink)As a workaround, i used the tomahawk **savestate **component for the elements of the datatable. This component stores the state of objects passed as value expression in the component tree (having a scope that spans between the inital request restore view and post back render response phase) . Seam has a page scope for that.
- Validation errors when using a converter in selectOne* components and not overriding the equals() method for the type of object in the list. More explanation here : [http://www.crazysquirrel.com/computing/java/jsf/converter-validation-error.jspx](http://www.crazysquirrel.com/computing/java/jsf/converter-validation-error.jspx)
-  Saving state on client side with hidden fields and having conversion or validation issues with a backing bean of request scope: state is lost. For instance, you have an _**inputHidden**_ component in your form and for a reason or another a form's field has conversion or validation issues. The backing bean of request scope is not updated for the postback request. The bean used to display the response is new and the **inputHidden**'s field value is reset. Once again this shows a lack of page context for state that needs to be kept between the initial request and the postback request.
- Programmatic submission of a web form in javascript through form's _submit_ method won't work because the actionlistener is registred on a **commandButton** and when the form is submitted, the submit button parameter is not passed in the request. The button's action event is not put in the event queue. A workaround is to programmatically click on the form's command button.

