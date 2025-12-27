---
layout: post
title: A simple Bar-Code generator with basic features.
tag: servicenow
--- 



 {{page.title}}
======================================================




<p>Today, let's take a look at how to create a Bar code label in ServiceNow. I've seen this being asked so many times, and recently here: http://community.servicenow.com/forum/8960. This started me off, and here is it.</p><p>The end product will look like this :<a href="http://servicenowdiary.com/wp-content/uploads/2013/05/ServiceNow-Service-Automation-2013-05-05-08-38-43.png"><img class="aligncenter size-medium wp-image-615" alt="ServiceNow Service Automation 2013-05-05 08-38-43" src="http://servicenowdiary.com/wp-content/uploads/2013/05/ServiceNow-Service-Automation-2013-05-05-08-38-43-300x185.png" width="300" height="185" /></a></p><p>1. We will have a UI Page, where you can specify the table name, 2 column names( this will take the top two columns of the barcode ), and the column name you want to barcode-code(if you leave this blank, then it will automatically encode sys_id)</p><p>The barcode landing page will look something like this :<a href="http://servicenowdiary.com/wp-content/uploads/2013/05/landing-page.bmp"><img class="aligncenter size-medium wp-image-613" alt="landing page" src="http://servicenowdiary.com/wp-content/uploads/2013/05/landing-page.bmp" /></a></p><p>Note: I've not even touched a tiny bit of CSS to the above page. If you are interested in having a great look using CSS, just add style tags, or import a style sheet into your UI page as discussed <a href="http://chrishann.net/posts/2012/12/3/servicenow-style-sheets-and-caching">here</a>.</p><p>2. We will have a Global button called "Print Barcode". This is a global button, and will appear in all those tables which have entry in a table called barcode_template table. The barcode_template table will store the preferences such as Column names that should appear, and the column name that needs to be encoded, along with the table name. A sample of data in barcode_template table:<a href="http://servicenowdiary.com/wp-content/uploads/2013/05/ServiceNow-Service-Automation-2013-05-05-08-35-30.png"><img class="aligncenter size-large wp-image-614" alt="ServiceNow Service Automation 2013-05-05 08-35-30" src="http://servicenowdiary.com/wp-content/uploads/2013/05/ServiceNow-Service-Automation-2013-05-05-08-35-30-1024x198.png" width="625" height="120" /></a></p><p>Now, lets go into how we do it:</p><p>All the magic happens with a jQuery plugin called BarCode Generator hosted here  <a href="http://barcode-coder.com/en/barcode-jquery-plugin-201.html">Barcode generator</a>. All I had to do was to get it into a UI Script and write a simple UI Page, to take the table name, and the columns and then encode it and display the results.Lets start by creating a simple landing UI page:</p>

**Name:** Barcode_landing

HTML:

```xml

<?xml version="1.0" encoding="utf-8" ?>
<j:jelly trim="false" xmlns:j="jelly:core" xmlns:g="glide" xmlns:j2="null" xmlns:g2="null">

<div style="margin:auto">

TableName: <input type="text" name="tname" id="tname"/><br/>

<label>You can specify 2 columns, comma separated, and they will be displayed in the first two columns of Barcode Label.</label><br/>
ColumnName(s): <input type="text" name="cname" id="cname"/> <br/>

<label> Column name to be barcoded </label><br/>
Field to be Barcoded: <input type="text" name="fname" id="fname"/> <br/>
Encoded Query: <input type="text" name="enc" id="enc"/> <br/>

<input type="button" onclick= "fnSubmit()" name="GetLabels" value ="GetLabels"></input>


</div>
</j:jelly>

```

Client Script:

```javascript
function fnSubmit(){
    
    window.location = "/barcode_generator.do?tname="+$('tname').value+"&cname="+$('cname').value+"&fname="+$('fname').value+"&enc="+$('enc').value+"&stub=no";
    
    
    
}
```




Here in the above UI page, we take all the inputs from the user, and send it to another UI Page. Notice the parameter, *stub* which is *no*, if we are doing it from this UI page - in bulk , or is it from the UI action on a particular table, for which the value will be *yes*. tname corresponds to Table Name,cname corresponds to comma separated column names, that take the two columns of the Label, fname corresponds to the field to be encoded and enc corresponds to encoded query.If you leave it blank, all the rows from the table tname, will be Barcode labeled.

Now, let's talk about the UI page that generates the Barcode:

**Name:** Barcode_Generator

**HTML:**



```xml

<!--?xml version="1.0" encoding="utf-8" ?-->

//Get all the parameters from the URL using the RP object.
//Check if you are coming from a UI page, or from a UI action
//Yes = from UI action, No = from UI page(bulk)
stub = RP.getParameterValue('stub');
//Get the table name.
tname = RP.getParameterValue('tname');

//If it is from the UI page, then you already have all the information specified in the UI page.
if(stub == 'no'){
//Get the comma separated column names, and store it in an array.
cname = RP.getParameterValue('cname').split(',');
//Get the field name to be barcode encoded into fname.
fname = RP.getParameterValue('fname');

if(fname == ''){
//If nothing is specified, by default take the sys_id and encode it.
fname = 'sys_id';
}
}

//If coming from the UI action on the table(single record barcode generate)
else if(stub == 'yes'){
//Glide the barcode template table, and get the column name, and field name from the table record for that //table
var grTab = new GlideRecord("barcode_template");
grTab.addQuery('tablename',tname);
grTab.query();

if(grTab.next()){
cname = grTab.column.split(',');
fname = grTab.fname;

}
}

//Finally get the encoded query - 
enc = RP.getParameterValue('enc');

gr = new GlideRecord(tname);
gr.addEncodedQuery(enc);
//Prepare the gr object
gr.query();

</g:evaluate>

<head>
<!-- Include jQuery -->
<script type='text/javascript' src='jQuery.min.jsdbx'></script>

<!-- Include Barcode Generator,Link below. -->
<script type='text/javascript' src='barcode.min.jsdbx'></script>

<!-- take care of some CSS styles. -->
<style>
p.thicker {font-weight:900;}
table,td
{
border:1px dotted #98bf21;
text-align:center;
font-weight:1900px;
font-size: 120%;

},


</style>
</head>
<body>
<div style="margin-left:5cm">
<table width="732" >

<!-- The rest is pure jelly xD -->
<j:while test="${gr.next()}">
  <tr>
    <td width="359" height="64"><p class="thicker">${gr.getValue(cname[0])}</p></td>
    <td width="357"><p class="thicker">${gr.getValue(cname[1])}</p></td>
  </tr>
  


  <tr >
    <td colspan="2" width="732" height="78" align="center">

<!-- This div is a placeholder for the Barcode. We recognize it with the class, and encode the id.Check the Client Script.-->
<div style="margin:auto;" id="${gr.getValue(fname)}" class="bcode"> </div>


</td>
  </tr>
<tr style="border:none;background-color:#EAF2F3;">
<td  colspan="2" style="border:none;background-color:#EAF2F3;">
$[sp]
</td>

</tr>
 
</j:while>

</table>
</div>
</body>

</j:jelly>
```

Now, here is the place where we insert the Barcode -

**Client Script:**

```javascript
(function($){
  
	$('.bcode').each(function(){ $(this).barcode($(this).attr("id"), "code128");     })
    
})($j||jQuery);

```

**-- This ends the bulk Bar code Generation --**

Let's now talk about generating it being on a record of a table. For that I've created a UI action like this:

Name: Print Barcode
Table: Global
client: checked
onClick : showBarCode()
Condition: new BarCode().isThere(current.getTableName())


```javascript

function showBarCode(){
   var url =' /barcode_generator.do?        tname='+g_form.getTableName()+'&enc=sys_id='+g_form.getUniqueValue()+'&stub=yes'; 
    popupOpenStandard(url);
    
}

```

OKay, now we are done, except for a Script Include by the name *BarCode* that we use to validate if we have to show that button on a particular table. Here is the Script Include:

```javascript

var BarCode = Class.create();
BarCode.prototype = {
    initialize: function() {
    },
    
    isThere:function(tName){
        var gr = new GlideRecord("barcode_template");
        gr.addQuery('tablename',tName);
        gr.query();
        if(gr.next()){
            return true;
        }
        return false;
        
    },
    
    
    type: 'BarCode'
}

```

Easy ain't it? Couple of things to wrap this post up:

Firstly - You can download the barcode jQuery plugin from <a href="http://barcode-coder.com/en/barcode-jquery-plugin-201.html"> Barcode Generator </a>

Secondly - As I have told many times, I'm not a very good CSS designer. So I only worked with basics here. Feel free to improve upon the CSS.

Three - If you have noticed the UI page, you will know any layout is possible. So mix and match HTML and come up with the layout that you need.

Most important: To push a jQuery plugin into a ServiceNow UI Script, you sometimes need to tweak it a tiny little bit, as it conflicts with Prototype. I'll soon write a post on it, but until then you can use the UI Script here: <a href="https://docs.google.com/file/d/0B7F5ETTqhZmEZVdHTHZCd0t1SW8/edit?usp=sharing"> Barcode UI Script </a> and use it in your instance.

Here is the update set: <a href="https://docs.google.com/file/d/0B7F5ETTqhZmESWlvdTV2ZGs0YlE/edit?usp=sharing"> Barcode Generator - ServiceNow Update set </a>

Let me know what you think in the comments!



