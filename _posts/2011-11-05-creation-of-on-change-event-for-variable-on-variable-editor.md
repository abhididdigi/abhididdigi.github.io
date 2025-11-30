---
layout: post
title: Creating an 'onChange' Event for a Variable in the Variable Editor
tag: servicenow
---



 {{page.title}}
======================================================




**Requirement:** You want to modify the value of any variable on the Variable Editor and need to hide/show corresponding variables dependent on this variable.

I had gone through the entire community posts and many other blogs, but I could not get any pointers. Finally, the great DOM came to my rescue.

Here is how I achieved `onChange` on any variable that is on the Variable Editor. This is just a draft of my idea, and the solution may not be optimal. I am working on making it better.

<a href="http://wiki.service-now.com/index.php?title=Client_Scripts#Adding_another_event_Handler">Adding another event Handler</a>

On this page, there is an explanation of how we can add an event to a page. But the problem with the Variable Editor is that the ID of the variables on the editor changes from one task record to another, making it difficult to get the ID of the element. I have written an `onLoad` script that will attach an `onChange` event.

```javascript
function onLoad() {
var x=document.getElementsByTagName("select");//Get all the select boxes,as my requirement was related to a select box,so I got all those elements.
elementId = x[2].name;//This code will get the ID of  third select box on the page. I need to improve on this line of code

var control = g_form.getControl(elementId);//gets the control of the element
control.onchange = myOnChange;
}

function myOnChange() {

var a = document.getElementById(elementId);
var b= a.value;
alert(b);
alert('Oh.. Did I just change? Yes I did,and my new value is this?! '+ b);
}
```

This code is pretty simple. I'm not sure why it wasn't anywhere else.

Any suggestions are welcome!