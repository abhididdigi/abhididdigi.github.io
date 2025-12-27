---
layout: post
title: Custom HTTP GET Request to a Server
tag: servicenow
---



 {{page.title}}
======================================================




I need to send a custom GET request from a dynamic XML generator over the HTTP protocol. The HTTP option in the Data Source wasn't working because there was no static file at the given location; it generates the XML on the fly. So, I needed to write my own custom HTTP GET request.

Thanks to Loyola Ignatius for identifying the authentication glitch and providing the necessary auth functions, and to John Anderson for helping me out with parsing the response object.

Now, let's move on to the GET request construction.

```javascript

 Assumption: The link if its something like this
http://abhcde.servicenow.com/ADG/SendEntries.nsv/3E337078Cfh44560A85257904006E96EA?SendEntries

var httpclient = Packages.org.apache.commons.httpclient;
var HttpClient = httpclient.HttpClient;
var UsernamePasswordCredentials = httpclient.UsernamePasswordCredentials;
var GetMethod = httpclient.methods.GetMethod;
var client = new HttpClient();
var AuthScope = httpclient.auth.AuthScope;
var authScope = new AuthScope("abhcde.servicenow.com", 80, null);

var credentials = new UsernamePasswordCredentials("********", "********"); //username and Password
client.getState().setCredentials(authScope, credentials);
var get = new GetMethod( "http://abhcde.servicenow.com/ADG/SendEntries.nsv/3E337078Cfh44560A85257904006E96EA?SendEntries");
get.setDoAuthentication( true );
var status = client.executeMethod( get );
var result = get.getResponseBodyAsString();
gs.print(result);
// From here, start the code for parsing the XML using XPath, which I will write in another post.
}
```

More on `AuthScope`:
<a href="http://hc.apache.org/httpclient-3.x/apidocs/org/apache/commons/httpclient/auth/AuthScope.html">http://hc.apache.org/httpclient-3.x/apidocs/org/apache/commons/httpclient/auth/AuthScope.html</a>

All the classes are Java classes, so you will find the documentation at:
<a href="http://hc.apache.org/httpclient-3.x/apidocs/org/apache/commons">http://hc.apache.org/httpclient-3.x/apidocs/org/apache/commons</a>