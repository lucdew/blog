--- 
layout: post
date: 2006-05-25
title: Use your VOIP softphone @work
wordpress_id: 191
wordpress_url: http://www.dewavrin.info/?p=191
comments: true
categories: 
- general
tags: 
- asterisk
- voip
- vpn
- security
- firewall
permalink: use-your-voip-softphone-work-2
---
Some VOIP softphones like X-lite rely on [SIP](http://en.wikipedia.org/wiki/SIP) (connection) and [RTP](http://en.wikipedia.org/wiki/Real-time_Transport_Protocol) (voice) protocols which both work on top of UDP.

In previous posts ([1](/blog/passing-through-corporate-firewall/) and [2](/blog/passing-through-corporate-firewall-part2-2/)), I explained how to create a tunnel between a machine in a corporate networkand an external machine (like your home machine). The solution was based on SOCKS capabilities of a ssh tunnel which can behave like a Socks proxy server (-D optionof openssh).

With recent versions of openSSH, SOCKSv5 is even supported and therefore it becomespossible to tunnel UDP. Unfortunately, I haven't found any Socksv5 compliant VOIP softphone.

To tunnel UDP over a TCP tunnel (a SSH tunnel) a combination of netcat and named pipescan be used (like explained [here](http://zarb.org/~gc/html/udp-in-ssh-tunneling.html)). The main disadvantage of this solution is that youhave to create a UDP to TCP pipe on one side of the tunnel and a TCP to UDP pipe on the other side for each remote port you have to access (5060 for SIPand 8000 for RTP by default).

Another solution is to create a VPN over your SSH tunnel.I chose [vtun](http://vtun.sourceforge.net) for its ease of you use but you could use other VPN over SSL solutions like openvpn.Note that there aren't any Windows client for vtun. Openvpn can have Windows client and can create ethernet bridges (bridging the 2 virtual interfaces of your VPN tunnel.

Anyway with vtun you'll be able to tunnel udp over a SSH tunnel. Beware that creating a VPN on top of a SSH tcp tunnel you expose your corporate network to attacks coming from your home network...I won't detail here all the steps to create the solutions but only give an overviewof each step and refer to links:

- 1) Configure your SSH daemon on your home machine. Use xinetd possiblyto forward connections on port 443 to port 22.
- 2) Use corkscrew and ssh to establish a tunnel between your workstation at workand your home machine through your office proxy and firewall (on local and remote port 5000 in the following example).
<pre>ssh -F ~/.bin/config -g -N -L 5000:localhost:5000 foo@home</pre>

- 2bis) If your corporate proxy requires NTLM authentication you can use [NTLM maps](http://sourceforge.net/projects/ntlmaps/) and connect corkscrew to the listen port of NTML maps.
- 3) Configure and run vtun server on your home machine (See [this](http://www.linuxjournal.com/article/6675)).
- 4) Also, configure and run vtun client on a Linux machine inside your corporate network.
- 5) Configure routes properly to access the SIP proxy through your VPN ([asterisk server](http://www.asterisk.org/) at homeor Internet SIP server).
- 6) Just configure your SIP phone as if you had direct access to the server (if you don't nat).![](/images/custom/xlite.JPG)
