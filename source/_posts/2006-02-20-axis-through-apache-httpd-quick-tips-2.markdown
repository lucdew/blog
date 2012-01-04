--- 
layout: post
title: Axis through Apache HTTPD quick tips
wordpress_id: 197
wordpress_url: http://www.dewavrin.info/?p=197
comments: true
categories: 
- java
tags:
- axis
- webservices

---
Here are tips when using Axis Web services through Apache:

- **Gzip** To enable gzip compression use the recommendations of the following blog entry. It consists in using [ Jakarta commons httpclient](jakarta.apache.org/commons/httpclient/) and configuring your Axis stub to set gzip compression on. On Apache 2.0.X, mod_deflate module can be used and it's pretty straightforward to enable gzip compression for input and output streams.
{% codeblock %}
<Location /ws>;
 SetOutputFilter DEFLATE
 SetInputFilter DEFLATE
</Location>
{% endcodeblock %}

Gzip can be enabled by Mime-type but it didn't seem to work for me... Enabling gzip compression is only advised when you have "large" messages (100 Kbytes). Benchmark it.

- **Preserve Host**
 When the WSDL is generated via Axis servlet, the _Host_ HTTP header is used to build the URL of WS endpoints in the WSDL. So if you are using mod_proxy to forward HTTP request to a servlet container don't forget to add this instruction.
{% codeblock %}
ProxyPreserveHost On
{% endcodeblock %}

Here's a sample configuration (mod_proxy, mod_proxy_http must be enabled).

{% codeblock %}
# Configure mod_proxy as a reverse proxy only
ProxyRequests Off
# To preserve HOST HTTP/1.1 header
ProxyPreserveHost On

ProxyPass http://j2eeserver:80/ws
ProxyPassReverse http://j2eeserver:80/ws
SetOutputFilter DEFLATE
SetInputFilter DEFLATE
{% endcodeblock %}

- **Dealing with SOAP with attachments**. mod_proxy can be used in front of any servlet container but when the Web containers are clustered it's better to use the relative Apache module of these containers (mod_jk for Tomcat or mod_wl_20 for Weblogic). The problem is that some modules don't handle well HTTP chuncked-encoding transfer type. Chunck-encoding is used by default by [Jakarta commons httpclient](http://www.dewavrin.info/wp-admin/jakarta.apache.org/commons/httpclient/) library (see [ this RFC description](http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html) of chunck-encoding). If you do SOAP with attachments with a Mime-Multipart HTTP request, the proxy alters the HTTP headers of the request and Axis doesn't handle it well. The only solution for me has been to use the latest mod_proxy version.Here's a sample request:

{% codeblock %}
POST /ws/Call HTTP/1.1
Content-Type: multipart/related; type="text/xml"; start=""; 	boundary="----=_Part_1_29493424.1136228652812"
SOAPAction: ""
User-Agent: Axis/1.3
Host: localhost:81
Transfer-Encoding: chunked
 
542
 
------=_Part_1_29493424.1136228652812
Content-Type: text/xml; charset=UTF-8
Content-Transfer-Encoding: binary
Content-Id: 
 
me31
------=_Part_1_29493424.1136228652812
Content-Type: text/xml
Content-Transfer-Encoding: binary
Content-Id: 
 
------=_Part_1_29493424.1136228652812--
{% endcodeblock %}

And here are the altered HTTP headers (behind the Weblogic mod_wl_20 proxy). The Content-length header is missing. The request is not chuncked encoded anymore and it makes Axis unable to find the Mime part of the SOAP-Enveloppe and the Mime part of the attachment.

{% codeblock %}
POST /ws/Call HTTP/1.1
Host: localhost:8081
Content-Type: multipart/related; type="text/xml"; start=""; 	boundary="----=_Part_1_810652.1136228287250"
SOAPAction: ""
User-Agent: Axis/1.3
Max-Forwards: 10
X-Forwarded-For: 192.168.0.1
X-Forwarded-Host: localhost:81
X-Forwarded-Server: gateway
{% endcodeblock %}

<u>**About Weblogic module for Apache**</u>

I wish BEA could opensource their proxy module for Apache. In front of a Weblogic cluster it's the only module for Apache that can be used because the module keeps a list of alive members of the cluster (by connecting to one of the cluster members). The list of the cluster members is returned to the mod_weblogic module in an encoded form. See the X-Weblogic-Cluster-List header below.

{% codeblock %}
X-WebLogic-Cluster-Hash: 4VGHN1gZDEo+SVsK2yjMU+4La3w
X-Powered-By: Servlet/2.4 JSP/2.0
X-WebLogic-Cluster-List: 1468479224!-1407317905!7002!-1|648190806!-1407317905!7003!-1
{% endcodeblock %}

I haven't figured out what the X-Weblogic-Cluster-Hash is and how it's generated (=&gt; a decompilation of Weblogic classes) should do it but in the X-Weblogic-Cluster-List you can see the inversed IP addresses and port of the cluster members in numerical format. Here 's a class to retrieve the IP address from the inversed numerical format.
Try: GetIP 1407317905

{% codeblock lang:java %}
public class GetIP {
 
  public static void main(String[] args) throws Exception {
    long a= Long.parseLong(args[0])  ;
    long b = ~a;
    StringBuffer ip=new StringBuffer();
    for (int i=1;i<=4;i++) {
       long c=b>>(8*(4-i));
       c = c & 255;
       ip.append(Long.toString(i==4?c+1:c));
       ip.append(".");
    }
    System.out.println(ip.substring(0,ip.length()-1));
 
  }
 
 
}
{% endcodeblock %}
