--- 
layout: post
title: Use your VOIP softphone @work
wordpress_id: 191
wordpress_url: http://www.dewavrin.info/?p=191
categories: 
- general
tags: 
- asterisk
- voip
- vpn
---
Some VOIP softphones like X-lite rely on [SIP](http://en.wikipedia.org/wiki/SIP) (connection) and [RTP](http://en.wikipedia.org/wiki/Real-time_Transport_Protocol) (voice) protocols which both work on top of UDP.In previous posts ([1](http://www.jroller.com/page/ldewavrin/20050310) and [2](http://www.jroller.com/page/ldewavrin/20041029)), I explained how to create a tunnel between a machine in a corporate networkand an external machine (like your home machine). The solution was based on SOCKScapabilities of a ssh tunnel which can behave like a Socks proxy server (-D optionof openssh).With recent versions of openSSH, SOCKSv5 is even supported and therefore it becomespossible to tunnel UDP. Unfortunately, I haven't found any Socksv5 compliant VOIP softphone.To tunnel UDP over a TCP tunnel (a SSH tunnel) a combination of netcat and named pipescan be used (like explained [here](http://zarb.org/~gc/html/udp-in-ssh-tunneling.html)). The main disadvantage of this solution is that youhave to create a UDP to TCP pipe on one side of the tunnel and a TCP toUDP pipe on the other side for each remote port you have to access (5060 for SIPand 8000 for RTP by default).Another solution is to create a VPN over your SSH tunnel.I chose [vtun](http://www.dewavrin.info/vtun.sourceforge.net) for its ease of you use but you could use other VPN over SSL solutions like openvpn.Note that there aren't any Windows client for vtun. Openvpn can have Windowsclient and can create ethernet bridges (bridging the 2 virtual interfaces of your VPN tunnel).Anyway with vtun you'll be able to tunnel udp over a SSH tunnel. Beware thatcreating a VPN on top of a SSH tcp tunnel you expose your corporate network to attacks coming from your home network...I won't detail here all the steps to create the solutions but only give an overviewof each step and refer to links:- 1) Configure your SSH daemon on your home machine. Use xinetd possiblyto forward connections on port 443 to port 22.
- 2) Use corkscrew and ssh to establish a tunnel between your workstation at workand your home machine through your office proxy and firewall (on local and remote port 5000 in the following example).
<pre>ssh -F ~/.bin/config -g -N -L 5000:localhost:5000 foo@home</pre>- 2bis) If your corporate proxy requires NTLM authentication you can use[NTLM maps ](http://sourceforge.net/projects/ntlmaps/)and connect corkscrew to the listen port of NTML maps.
- 3) Configure and run vtun server on your home machine (See [this](http://www.linuxjournal.com/article/6675)).
- 4) Also, configure and run vtun client on a Linux machine inside your corporate network.
- 5) Configure routes properly to access the SIP proxy through your VPN ([asterisk server](http://www.asterisk.org/) at homeor Internet SIP server).
- 6) Just configure your SIP phone as if you had direct access to the server (if you don't nat).![](http://www.jroller.com/resources/l/ldewavrin/xlite.JPG)