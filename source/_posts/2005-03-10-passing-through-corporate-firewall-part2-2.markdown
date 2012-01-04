--- 
layout: post
title: Passing through corporate Firewall (Part2)
wordpress_id: 214
wordpress_url: http://www.dewavrin.info/?p=214
comments: true
categories: 
- general
tags:
- security
- firewall

---
[Last time](http://www.jroller.com/page/ldewavrin/20040819) I have used the combination of proxytunnel and SSH to connect tomy home machine from a corporate network behind a firewall and proxy. But it seems that proxytunnel is unableto pass through Microsoft ISA Proxy server. At least, I have tried with the -u  and -p  arguments of proxytunnels and it didn't work (even with a username following this pattern domain\username or username@domain) The Microsoft ISA proxy server requires NTLM authenticationand there's another combination that worked successfully to be able to connect through it to an external machine on SSL :[Ntlmaps](http://ntlmaps.sourceforge.net/), [Corkscrew](http://www.agroman.net/corkscrew/) which tunnels ssh through HTTPS and of courseSSH.

Ntlmaps is a Python program that acts as a proxy software that allows you to authenticate via an MS Proxy Server using the proprietary NTLM protocol. Once downloaded, all you need is to configure the hostname/port of your corporateproxy and your Windows domain username/password (I left other options with their default values).

Corscrew can be compiled with Cygwin tools under Windows. Once compiled and installed configure SSH to use it. In order to do so, edit your ~/.ssh/config file and use the following command:
<pre lang="text"> ProxyCommand /usr/local/bin/corkscrew 127.0.0.1 5865 %h %p</pre>

Corkscrew will use your local ntlmaps proxy server which in turn is authenticated on Microsoft proxy server. Then use SSH (openSSH) like this :
<pre lang="text"># ssh -C -N -D 1080 -p 443 root@myhomemachine</pre>

\-D to use the SSH daemon at the other side of the tunnel as a Socksv5 proxy server. It will listen locally on port 1080
- -C for compression
- -D to not start a shell

Then you can configure your software to use the Socks proxy server on localhost port 1080
