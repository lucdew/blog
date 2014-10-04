--- 
layout: post
date: 2004-10-29
title: Passing through corporate firewall
wordpress_id: 131
wordpress_url: http://www.dewavrin.info/?p=131
comments: true
categories: 
- java
tags:
- security
- firewall
permalink: passing-through-corporate-firewall
---
 Well, at least from inside your corporate network ;-)to surf, chat and more anonymously.

After reading this [blog article ](http://blogs.cadince.com/blojsom/blog/dan/?month=8&year=2004)thanks man) and its comments, I tried it and I have to say thatI have been happily surprised how easy it was. I didn't know the existence of proxytunnel and that's the key in it (for the theory about establishing a Ssh connectionthrough a SSL proxy see [here](http://proxytunnel.sourceforge.net/papers/muppet-200204.html)).

Proxytunnel allows you to establish a SSH connectionvia a corporate proxy (all proxies that supports the CONNECT command). Here a schema of the solution I adopted :
{% codeblock %}
Schema                                                    |Internet
                                                          |
 -----------    SSL     -------------   SSL  ---------   SSL    443--------------
| Windows WS| --------| Company Proxy |-----| Firewall|--------| Home SSh Server |
|           |         |  "CONNECT TO" |     |         |   |    |                 |
-----------           ---------------        ---------    |     -----------------
        
{% endcodeblock %}

The other major point in this solution is the usage of a Socks5 server that will allow you to connect to any machine of your internal network with any Socks5 compliant software. A socks5 proxy is a proxy on layer4 of OSI model. For example, I have been able to establish a VNC connection to a Windows XP machine on my home network with "Smart CodeVNC manager" that has Socks5 capabilites.

Here are the steps I followed.

1) First check the prequesites

Tools needed on client side (we'll make the assumption that it runs on Windows)
- cygwin with ssh client
- proxytunnel cygwin port ( http://proxytunnel.sourceforge.net)

Server side prerequisites: 
- SSH daemon and that's it.
- Port 443 opened.
- Optional: xinetd or a NAT tool to do port redirection (I used OpenBSD packet filter to redirect connections on port 443 on my Internet gateway to an internal Linux server in my home network).

2) SSH server configuration

The only thing to do is to configure it to listen on port 443 and authorize root loggin. Or you can use xinetd to use port redirection or any NAT tool ( PF, Netfilter...) and leave the server run on port 22.

3)  Client SSH configuration
In a cygwin terminal, create a $HOME/.ssh/config file and add the following lines:

<pre lang="text">Host myserver   KeepAlive yes   ProxyCommand path_to_proxytunnel/proxytunnel.exe -g proxy_ip_address -G proxy_port -d ssh_server address -D ssh_server_port</pre>

The ssh server port should be 443.

4) Establish the ssh tunnel

In one command, you establish a SSH tunnel with SOCKS5 capabilities to your remote SSH server.
{% codeblock %} 
# ssh -D 1080 -l root myserver
{% endcodeblock %}

update: use -N to avoid opening a Shell and -C for compression

Actually, the -D enables dynamic port redirection and listens on local port 1080.Connections are tunneled through SSH and are on the other side of the tunnel made by the remote SSh server (which behaves as a Socks proxy). ssh can also understant SOCKS5 protocol therefore you know have a Socks5 server that listens on port 1080 locally. The SOCKS connections are tunneled and are remotely executed by your ssh server

5)  Configure your Workstation software to use the Socks5 server on port 1080 on localhost and enjoy.

Note that you can use IP of your remote internal network, you created "a kind of VPN"for SOCKS5 compliant software. For example, let's say that you have on your home network a Web server that runs on the private address 192.168.1.2. You can now reach it by typing in firefox http://192.168.1.2. 

Also don't forget to use a firewall on your workstation or your coworkers will gladly be able to connect to your Socks5 proxy.
