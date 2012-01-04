--- 
layout: post
title: Boost Eclipse performance under Windows
wordpress_id: 134
wordpress_url: http://www.dewavrin.info/?p=134
comments: true
categories: 
- java
tags:
- eclipse

---

There's an excellent Eclipse plug-in to prevent Windows from swapping to disk the memoryallocated to the Eclipse's JVM.

The [keepresident plug-in](http://suif.stanford.edu/pub/keepresident/) really improved Eclipse overall performance.

Sometimes Eclipse3 used to freeze for 10-20 seconds.Even after tweaking the JVM options (-XX:+UseParallelGC -Xms512m -Xmx512m -XX:MaxPermSize=96M on a 1Gbytes machine), it was still freezing randomly. I thought it was the GC on my mono-processor machine which was causing a "stop the world " for all other threads (i didn't trace it with the -verbose:gc). But actually, it seems that Windows was involved and deeply deteriorated the performance of Garbage Collection by swapping to disk even when there was still free physical memory ( like when the Eclipse Window is minimized). Now Eclipse is really fast !

Congratulations to the plug-in's author
