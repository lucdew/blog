--- 
layout: post
date: 2006-12-18
title: Gwt client with rails backend integration tip
wordpress_id: 188
wordpress_url: http://www.dewavrin.info/?p=188
comments: true
categories: 
- java
tags:
- rails
- gwt

permalink: gwt-client-with-rails-backend-integration-tip-2
---
<p>
Writing a rich web interface in Java and server side code in ruby : pretty unsual isn'it ? But hey after all, web client interfaces get everyday more complex and are mix of technologies. Gwt sounds interesting since you write your complex web UI components like you'd write a Swing widget, mostly in Java. 
Then, unlike echo2  you can compile your Gwt code to Javascript and Html and deploy it in any Web server.So, if you would like to invoke a rails service with a Gwt client and getsa Json response here are the steps to achieve this kind of stuff.
</p>

1) Create a Gwt JSNI class to invoke your rails service.

Update 12/17/06: Since GWT 1.2.2, you can achieve this without writing your own JSNI class, by using the GWT [RequestBuilder](http://code.google.com/webtoolkit/documentation/com.google.gwt.http.client.RequestBuilder.html) class which provides a method to set your own http header.[Java Script Native Interface ](http://code.google.com/webtoolkit/documentation/com.google.gwt.doc.DeveloperGuide.JavaScriptNativeInterface.html) is Google Web Toolkit equivalent of JNI but for Javascript. Java objects (which are BTW translated to Javascript code by GWT compiler) can interact with Javascript objects (and reversly).Rails **respond_to** method available in each controller can be used to respond to yourclient and deliver a different response for each mime type asked.Rails uses **Accept HTTP header** to differentiate the asked media type response.So the class [Java source file (broken link...)](http://www.dewavrin.info/code/HTTPJsonRequest.java) has static GET and POST methods which perform HTTP requests and especially set the accept HTTP header to 'text/json' . 
(I grabbed this code from the GWT mailing list and modified it a little bit).Then declare it in your GWT module.

{% codeblock lang:xml %}
<inherits name="biz.dewavrin.net.HTTPJsonRequest" />
{% endcodeblock %}

2) Enable rails to perform Json responses.Everything is explained [on this blog entry.](http://superfluo.org/blojsom/blog/pic/devel/2006/06/21/How-to-register-a-new-MIME-type-in-Rails.html)N.B: importing the json module is "superfluous" ;-) since it's packed with rails 1.1

3) Modify ROR active record base class to dump themselves as a Json data structure.

Add the following method (the code comes from rails wiki):

{% codeblock lang:ruby %}
def to_json(*)
 
  result = Hash.new
  self.class.content_columns.each do |column|
    result[column.name.to_sym] = self.send(column.name)
  end
  result.to_json
 
end
{% endcodeblock %}

4) In your rails controller, send a Json response when asked (note the call to the to_json method):

{% codeblock lang:ruby %}
def list
  @songs = Song.find(:all)
  respond_to do |wants|
    wants.json {
       render :text => @songs.to_json
    }
    wants.html {
        @song_pages, @songs = paginate :song, :per_page =&gt; 10
    }
  end
end
{% endcodeblock %}
and in your GWT client, the asynchronous HTTP request-response:

{% codeblock lang:java %}
 HTTPJsonRequest.asyncGet("http://localhost:3000/library/list", new ResponseTextHandler() {
        try { JSONValue jsonValue = JSONParser.parse(responseText); ... }
        catch (JSONException e) { // do nothing } 
 } );
{% endcodeblock %}

Note that this solution is limited for the following reasons:
- It's forbidden to do Java reflection in the GWT client. So you can'tinstantiate a JavaBean from a Json object in a generic way.I would have liked to add a type field in my Json data representationand have my Java code instantiate a bean.
- Gwt client limits usage of J2SE 1.4.2 to collection's API and some java.lang classes. See  [runtime library support](http://code.google.com/webtoolkit/documentation/com.google.gwt.doc.DeveloperGuide.Fundamentals.JavaToJavaScriptCompiler.JavaRuntimeSupport.html)
