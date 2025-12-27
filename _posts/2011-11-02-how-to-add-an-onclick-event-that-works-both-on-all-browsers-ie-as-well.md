---
layout: post
title: How to Add an Onclick Event That Works Across All Browsers
tag: servicenow
---

**Requirement:** You want to populate all the options on the Service Request Form dynamically from a table. So, you have written your own UI page to get all the options from a table. One of the problems in writing our own UI pages with all the "fields" we want is that we have to attach their event handlers and handle each and every validation.

In the process of validating them, we had a statement:

```javascript
var element1 = document.createElement("input");

element1.type = 'checkbox'; // Defining the type of the element

element1.id = 'checkbox'+i; // Just assigning some ID to the element created

element.setAttribute("onclick",'handlerfunction(this)');
```

It was working fine with Firefox, but when I tested it with IE, it wasn't working. This is one more reason for me to dislike IE.

**Reason:** `setAttribute` doesn't work in IE.

I explored all the links that Google gave me with little success. Finally, I thought of using the `observe` method of Prototype.

<img src = "http://upload.wikimedia.org/wikipedia/en/b/b2/PROTOTYPE.png"/>

<a href="http://www.prototypejs.org/api/event/observe">Prototype-Observe: Just a Click Away</a>

You can find everything about events in the link above. Also, one of the reasons I like Prototype when it comes to event handling is that you don't need to pass `this` to a handler function. The code is as simple as this:

```javascript
Event.observe(element1.id,'click',check);

/* Observe will "observe" if there are any events. If there is an event, it will check if there is a handler function
for that event. What we are doing here is registering the onclick event with the check function. */
```

The list of the events that can be attached is given in this link:
<a href="http://www.w3schools.com/jsref/dom_obj_event.asp">Event List</a>

Prototype is one of the few libraries that is extremely useful! Write less, do more.