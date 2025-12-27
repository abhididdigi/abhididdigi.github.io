---
layout: post
title: How to Use XPath Basics
tag: servicenow
---



 {{page.title}}
======================================================




Hello ServiceNow Diary,

It's very difficult for me to understand the recursive function for processing XML provided at this location:
<a href="http://wiki.service-now.com/index.php?title=XMLDocument_Script_Object#XMLHelper">Community Snippet</a>

All I want to do is process an XML document.

Regards,
Hiranya

Dear Hiranya,
That example is a very good way to process complex XML, but it may seem tough, especially if you are in a hurry.

To cover the basics of accessing a node:
*   `xmldoc.getNodeText("<Identifythenode>")` - This method is used to get the value of the node whose path is given in the parameters.
*   `xmldoc.getNode` is used to get a pointer to the desired node.
*   `xmldoc.getNodes("path-of-a-series-of-nodes*");`

Now, you would like to know how to get the path of the name. For this, I strongly recommend looking at the XPath tutorial on W3Schools.
<a href="http://www.w3schools.com/xpath/">XPath - W3C</a>

P.S. When you go through the examples on W3C, you will find that processing is done for Firefox and IE separately (and on the client-side), but on ServiceNow, you need not worry about this.

The entire process of processing the XML comes down to two simple steps:
1.  Identifying the node(s) you want to use.
2.  Using one of the methods to get the value of the node.


Also, you can store the node pointers in arrays by using the `getNodes()` method and process them using a `while` or `for` loop.
For example,
supposing the structure of XML you want to process is something like this:

```xml
<root>
<child>
<grandchild>
<text>something</text>
</grandchild>
<grandchild>
<text>something</text>
</grandchild>
<grandchild>
<text>something</text>
</grandchild>
<grandchild>
<text>something</text>
</grandchild>
</child>
<child>
<grandchild>
<text>something</text>
</grandchild>
<grandchild>
<text>something</text>
</grandchild>
<grandchild>
<text>something</text>
</grandchild>
<grandchild>
<text>something</text>
</grandchild>
</child>
</root>
```

The code will be something like this:

```javascript
var i=1;
var arr = [];
var check = xmldoc.getNodeText("//child[1]");
while(check != null){
for(var j=1;j<=5;j++){
var a =xmldoc.getNodeText("//child["+i+"]/grandchild["+j+"]/*");
arr[j]= a;
}
i++;
var check = xmldoc.getNodeText("//child[i]");
}
```

This is basic code. You can also count the nodes and use them in the loops. But I feel this way is cleaner—the old-school way with fewer functions and more code.

I hope this helped, Hiranya.

Cheers,
Service-Now Diary


 




-