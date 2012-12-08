---
layout: post
title: "svnsync to existing repository"
date: 2012-12-08 14:59
comments: true
categories: 
tags: svn
---

Basically I will explain how to synchronize with svnsync on an existing repository. I had trouble to find the info on the Internet so I am sharing it. I am by no mean a subversion administrator therefore if the info is not correct please be kind to let me know.

Yes I know subversion is not really 2013 but recently I had to synchronize a large master subversion repository with a slave. The slave had to be rebuilt from scratch. It turned out that synchronization with svnsync was really too slow to be considered. Therefore to speed up the process. I created a svn repository on the slave machine :
{% codeblock %}
svnadmin create myrepo
{% endcodeblock %}

And synced by dumping and loading through a ssh tunnel :
{% codeblock %}
svnadmin dump /var/subversion/myrepo | ssh remoteuser@remotehost "svnadmin load /var/subversion/myrepo "
{% endcodeblock %}

If you sync with svnsync it will complain that the repository has not been initialized with it (svnsync init). No panic, a bunch of revision properties for revision 0  have to be created.

The properties are:
- svn:sync-from-uuid : the uuid of the master repository. Can be found with the svn info command.
- svn:sync-last-merged-rev : the last merged revision. The synchronization will resume from it. So it has to be set the first time to the last revision, can be retrieved with svn log.
- svn:sync-from-url : The URL of the master with the file scheme like file:///var/subversion/myrepo.

Set the properties with the user that does the svnsync on the slave repository, example:
{% codeblock %}
svn propset --revprop -r0 svn:sync-from-url "file:///var/subversion/myrepo" file:///var/subversion/myrepo --username syncuser
{% endcodeblock %}
