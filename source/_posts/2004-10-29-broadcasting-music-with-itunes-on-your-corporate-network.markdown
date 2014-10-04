--- 
layout: post
date: 2004-10-29
title: Broadcasting music with Itunes on your corporate Network
wordpress_id: 130
wordpress_url: http://www.dewavrin.info/?p=130
comments: true
categories: 
- general
tags:
- misc
- firewall

permalink: broadcasting-music-with-itunes-on-your-corporate-network
---

Well,since most companies don&#39;t allow their employees to host mp3 on serversespecially on production servers ;-) Here&#39;s a little trick if you havea machine connected to the internet at home (with a fixed IP address ordyndns to easily connect to it) to listen your mp3.

Once again it uses SSL tunnel and SSH (See my previous [post](/blog/passing-through-corporate-firewall-part2-2/))to connect through your corporate firewalls and proxies to your homemachine. As a Itunes server I chose to use mt-daapd daemon on a Linuxserver. Here are steps:

1) On your home machine configure mt-daapd daemon. The step mostly consists in chosing the directory where your mp3s are.

2) Configure ssh on your corporate machine to use stunnel (See my previous [post](/blog/passing-through-corporate-firewall-part2-2/))

3)Configure the SSh daemon at home (See my previous [post](/blog/passing-through-corporate-firewall-part2-2/))

4) On your local machine, use RendezvousProxy toolhttp://ileech.sf.net/RendezvousProxy/ as a proxy for RendezVousprotocol. Itunes uses RendezVous protocol to automatically discover anyItunes server. It works with multicast packets (not investigated thatmuch on it).Configure RendezvousProxy to listen on port 3690 for instance and use daacp.tcp plugin.

5) Establish the SSL tunnel:
{% codeblock %}
# ssh -N -C -L 3690:mp3remotehost:3689 user@homegateway
{% endcodeblock %}
Where -N option does not open a shell. -C is for compression.-L is for port forwarding. 3690 is the local port open your machine.mp3host and 3689 are the hostname andport of your mt-daapd server. user and homegateway are the user andhost of your home gateway with whom you will establish the SSHconnection.

6) Start Itunes and your server should be listed in the left pane.
Enjoy!

I have tested it with my home internet connection which is a DSLconnection with 256 Mbits/s upload capabilities and it rocks. No need to tell your coworkers who use Itunes that you host a mp3 broadcasting server because if they are in the same LAN, they all should see it...

Ask you network administrator also to route IP multicast packets for the RDV address to make your whole company enjoy your mp3 server ;-)
