--- 
layout: post
title: Weblogic ant tasks
wordpress_id: 135
wordpress_url: http://www.dewavrin.info/?p=135
categories: 
- weblogic
tags:
- weblogic

---
<br />For having worked with many of the [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") ant tasks,it&#39;s really a pain to make them work with a standard ant(i.e: not the one bundled with [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues")).<br />I work under Eclipse3 with ant 1.6 and do some integration work of J2EE applications. Some of the [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") ant tasks like source2wsdd or wlappc just don&#39;t work without [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues")&#39;s ant. wlappc was supposed to be fixed with sp3 but it still doesn&#39;t work properly.The workarounds tomake these tasks work are: <br />. find the matching administration class and load the class with the "java" task<br />. create dynamically a command/shell script that will invoke the task with[Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues")&#39;s ant !<br /><br />Also, I tried the WLST scripting tool based on Jython. Of course calling itfrom the [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") &#39;s ant works fine but with a standard one it doesn&#39;t(even with Classpath set properly :-) ).<br /> That&#39;s why I decided to stick to wlsh( [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") shell: http://www.wlshell.com)which worked pretty well for me but is not officially supported by BEA (andhave limited scripting capabilites compared to Jython).<div>Update: actually wlst can be invoked from ant when the<br />fork option of the "java" task is set to true. But my complaints about the [Weblogic](http://edocs.bea.com/wls/docs81/notes/issues.html "Known issues") ant tasks <br />just remain </div><br /><div>I think BEA guys should really test these ant tasks and administration toolswith a vanilla ant. And generally, they should improve the quality of them,some have very limited features compared to the CLI tools and even some of the implementedfeatures are broken ! <br /><br />P.S: Next time I&#39;ll try to post technical stuff instead of complaining ...</div>
