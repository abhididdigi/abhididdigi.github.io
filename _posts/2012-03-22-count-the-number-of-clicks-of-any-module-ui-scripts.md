---
 layout: post
title: Count the number of Clicks of any module : UI Scripts
--- 
 {{post.title}}
======================================================
Happy Ugadi ! Ugadi is an Indian festival celebrating the beginning of a new year as per the Calendar of our State,also known as Telugu Calendar. But the most unique and significant tradition of Ugadi is beginning the new year with savoring a unique flavored pachadi (chutney) that epitomizes the spirit of Ugadi called “Ugadi Pachadi”,with sweet, sour, pungent and bitter tastes (shadhruchulu or six tastes). This chutney or sauce is a symbolic reminder of the myriad facets of life in a sense prepares us for the year ahead.

In this post I would be telling you how to count the number of clicks of a module  and store it in the User table(i.e the number of times each user had clicked on that module)

The two pieces of the solution are :

1.Writing a UI Script that creates an event every time the user clicks on a module

2.A script include which calculates the count, incrementing the existing count by 1.

The UI Script :

Name : CountModule

Active: true

Global : true
<pre lang="javascript">addLoadEvent( function() {
//If the script loads in the navigation frame
if (window.location.toString().indexOf('navigator.do') &gt; -1) {
//Attach an event to the click for our module
Event.observe($('module.e660172ac611227b00fa88fb47ae3fad'), 'click', function(event) {
var ele = Event.findElement(event, 'tr');
if (ele != document &amp;&amp; $(ele).id == 'module.e660172ac611227b00fa88fb47ae3fad') {
var ga = new GlideAjax('HelpdeskCount');
ga.addParam('sysparm_name','count');
ga.getXMLWait();

}
});

}
});</pre>
The only catch here is, you would have to determine the ID of your module before applying this script. Or you will not be able to access the Navigation bar at all ! Use Firebug to get the ID of the module and append a "module." to it.
Alternatively, you can always put an alert in the script itself to determine the ID of the module.

Step : 2

Create a new column in the sys_user table which will have the count of how many times the user clicked on the module.
In my example the name is u_helpdesk_count

Script Include :
Name :HelpdeskCount
Client : true
<pre lang="java">var HelpdeskCount = Class.create();

HelpdeskCount.prototype = Object.extendsObject(AbstractAjaxProcessor, {

count: function() {
var gr = new GlideRecord("sys_user");
gr.addQuery("sys_id", gs.getUserID());
gr.query();
if (gr.next()) {
gr.u_helpdesk_count = gr.u_helpdesk_count+1;
gr.update();
return gr.u_helpdesk_count;
}
return -1;

}
}
);</pre>
And this will increment the count each time the user clicks on the module. Though this is not a very great post, it explains the significance of UI Scripts.

Thanks to Mark of <a href="http:\\www.servicenowguru.com" target="_blank"> Servicenow Guru</a> for guiding me through his posts.