---
layout: post
title: [Quick-Tip] UI Macro Reference Qualifier
--- 



 {{post.title}}
======================================================




When i was very young to Service Now and was writing a UI macro with a UI:Reference macro embedded in it,I wanted to have a refQual to filter the records in it.
So as usual <a href="http:\\www.servicenowguru.com">Mark Stanger</a> came to my rescue and helped me complete my requirement.Thanks Mark.

You will find the trick to this lurking somewhere at the bottom of a post on SNCGuru, So lifting it so that it will come handy for most of us.

Quoting :
<pre lang="xml">          
< TD >
            <!-- Include the 'ui_reference' UI macro -->;
            <g:ui_reference>
          </TD>
</pre>
Me: How can I include a RefQual for this UI Macro?
<pre lang="javascript">Mark :Yes, if you want to use a reference field in a custom popup dialog, you should include the ‘ui_reference’ macro instead of the ‘ui_slushbucket’ macro. The basic code to include in your UI page looks something like this…

To access the value of that field when the ‘OK’ button is clicked, you can use a client script like this…
If you want to filter the entries in the reference field using a reference qualifier then you have to include an encoded query string using a special syntax in the 'Name' parameter.  That syntax looks something like this...

<g:ui_reference name="QUERY:active=true" table="REFERENCED_TABLE_NAME">

Because the ‘Name’ parameter ends up being the ID of the form element too in this case, you need to reference the field by this custom query string to get the value in your client script if you’ve applied a filter. This is a terrible design, but that’s just how it was developed. :)
//Get the value of the dialog reference field
var dialogFieldValue = gel('QUERY:active=true').value;</pre>
One must see that in the "name" of the UI Macro we are using a direct query. In some cases one would want to use a Global RefQual function in the place of a Direct Query.This is possible by appending a JavaScript to the function name you would want to invoke and put it next to 'QUERY' as shown.
<pre lang="javascript">var dialogFieldValue = gel('QUERY:javascript:functionName()').value;</pre>