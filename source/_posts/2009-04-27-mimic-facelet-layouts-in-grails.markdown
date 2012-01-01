--- 
layout: post
title: Mimic facelet layouts in grails
wordpress_id: 262
wordpress_url: http://www.dewavrin.info/?p=262
categories: 
- java
- tech
tags: 
- grails
---
<div>
I wanted to mimic facelets <ui:insert /> and <ui:define /> tags in grails.I find facelets to be quite powerful because it allows to define a fragment in your template that can be redefined by the view, otherwise a default fragment is displayed.It can be useful for instance for a menu where you want all views to use a default menu and some use another menu. 

In facelets, you would create a template file and add a <ui:insert /> statement for the menu, like this:
<pre lang="xml"><ui:insert name="menu"> <ui:include src="../frags/menu.xhtml" /></ui:insert></pre>Here the <span style="font-weight: bold" class="Apple-style-span">&lt;ui:insert/&gt;</span> statement by default includes with the help of the <span style="font-weight: bold" class="Apple-style-span">&lt;ui:include/&gt;</span>element a menu fragment (a partial page).<br />In your view you could if wanted redefine the menu with the <span style="font-weight: bold" class="Apple-style-span">&lt;ui:define/&gt;</span> element, like this:<pre lang="xml"><ui:composition template="layout/template.xhtml"><ui:define name="menu" /></ui:composition></pre><div> Override default menu here </div>
Grails template system is handled by sitemesh. To achieve the same goal, you can in your template file (layout/main.gsp for instance), add the following element for the menu :
<pre lang="xml"><g:pageproperty name="page.menu" default="${render(template:'/frags/menu')}" /></pre>It achieves the same purpose, actually instead of defining a page section like in facelets, it displays the calling page's <b>&lt;content&gt;</b> element named menu if present (control is inverted but the result is the same).Otherwise,  if the &lt;content&gt; element is not found,  the menu fragment is rendered.The fragment page should be in our example created in the frags directory under the name _menu.gsp.In your view, you can therefore define the menu section of your template by declaring a content element. <pre lang="xml"><html>   <head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><meta name="layout" content="main" /> <title>Show Book</title>  </head>  <body><content tag="menu" /><div>Override default menu here</div></content...  </body></html> </pre></div>
