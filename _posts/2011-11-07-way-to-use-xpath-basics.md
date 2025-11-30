---
layout: post
title: Way to use XPATH-Basics
--- 



 {{page.title}}
======================================================




Hello ServiceNow Diary,

It's very difficult for me to understand this very difficult recursive function for processing XML given in this location
<a link="http://wiki.service-now.com/index.php?title=XMLDocument_Script_Object#XMLHelper">CommunitySnippet</a>

All that I want to do is I have a XML document and I want to process it.

Regards,
Hiranya

Dear Hiranya,
That example is a very good way to process complex XML. But then it may *seem* tough, especially if you are in a hurry! ;)
To cover the basic stuff to access a Node:
**xmldoc.getNodeText("<Identifythenode>")** - This method is used to get the value of the node, whose node path is given in the parameters.
**xmldoc.getNode** is used to get a pointer to the desired node.
**xmldoc.getNodes("path-of-a-series-of-nodes*");**
Now you would like to know how to get the path of the name. For this I strongly recommend to have a look at the XPATH tutorial in w3schools.
<a link= "http://www.w3schools.com/xpath/">XPATH-W3C</a>
P.S. When you go through the examples in W3C, you will find that processing is done for Firefox and IE separately (also it is on the client-side) but on ServiceNow you need not worry about this.

Now the entire process of processing the XML comes down to simple two steps:
1. Identifying the node(nodes) you want to use the value
2. Using any of the method to get the value of the node.


Also, you can store the Node pointers in arrays, by using the getNodes() method, and process it using a while or for loop.
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

This is a basic code. You can count the nodes as well and use them in the loops. But I feel this way's clean, the oldschool's way with less functions and more code ;-)

Hope this helped Hiranya.

Cheers,
Service-Now Diary


 




-