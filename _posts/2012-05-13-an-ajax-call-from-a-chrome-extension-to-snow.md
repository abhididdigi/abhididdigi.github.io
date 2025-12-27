---
layout: post
title: An Ajax Call from a Chrome Extension to ServiceNow
tag: servicenow
---

<p>I was going through the ServiceNow community and I stumbled upon Simon Morris’s Chrome add-on, “The Totally Unofficial Chrome Add-on for ServiceNow.” I really liked the idea and wanted to do more with it.</p>

<p>The idea is to use the current interface but get more features, like:</p>
<ul><li>The top incidents that a person had raised, along with a summary of each when clicked on in a window.</li>
<li>Along with the incidents, the other must-haves (planned) are the list of all the problems, the list of all the service requests, and their summaries.</li>
</ul><p>When I say “top,” I mean the most recent ones or the most recently updated ones. I have tested integrating the add-on with some scripted web services of ServiceNow, and yes, it seems to be working.</p>
<p>The only problem here seems to be me getting accustomed to using the UI in the way dictated by Google Chrome.</p>
<p>I know I had a Firefox extension coming, but it’s still under construction. Once I am good with this Chrome extension, probably in the next couple of weeks, I will translate it for Firefox.</p>
<p>To make this thing work, I used the Ajax jQuery call, which worked like a charm.</p>
<p>Snippet here(of the call)&#160;:</p>
<pre class='"prettyprint'>  soapMessage += '';*/
	 soapMessage += '';
     soapMessage += '  ';
      soapMessage += '<a>' + 'helloworld' + '</a>';
     soapMessage += '';
     localStorage["last_record"] = 'incident';
     alert(soapMessage);
     $.ajax({
       url: "https://demo08.service-now.com/FirstCheck.do?SOAP",
       type: "POST",
       dataType: "xml",
       username: localStorage["username"],
       password: localStorage["password"],
       data: soapMessage,
       complete: createRecordCallback,
       contentType: "text/xml; charset=\"utf-8\""
```
<p>Weirdly enough, I wasn't able to execute the same successfully on a normal HTML page. I would be glad if someone could help.</p>