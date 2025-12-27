---
layout: post
title: How to Upload Affected CIs for a Change Request from a .csv or .txt Attachment
tag: servicenow
--- 



 {{page.title}}
======================================================




Happy New Year! This post will explain the functionality to upload a list of affected CIs from a .csv or .txt attachment for a change request. Thanks to <a href="www.servicenowguru.com">SNC Guru</a> for providing me with a couple of ideas on handling attachments in various ways.

**Assumption:** The .txt or .csv file will have one column with the names of affected CIs for a particular change request.

There are three parts to get this working:
1.  Identify the attachment from the `sys_attachment` table corresponding to a change request.
2.  Convert the attachment to a byte array, then convert the byte array to an array of strings.
3.  Insert the data into the `task_ci` table.

When I first had this requirement, I had very little information to work with—just a class called `SysAttachment` and a method called `getBytes` (inherited from the Object class).

I am handling the entire conversion of the attachment into an array of strings in the UI action itself. You can use a script include and call it from the UI action if you choose to make this client-callable.

**Name of the UI Action:** `AddCIs`

// This will only get the CI names from a .csv sheet. You can do a similar thing for a .txt file.

```javascript
var gr = new GlideRecord('sys_attachment');
gr.addQuery('table_sys_id', current.sys_id);
gr.addQuery('file_name','UploadCI.csv');
gr.addQuery('content_type','application/vnd.ms-excel');
gr.query();
if (gr.next()){
   var sa = new Packages.com.glide.ui.SysAttachment();
   var binData = sa.getBytes(gr);
   var string = new Packages.java.lang.String(binData);
   gs.log(string);var arr = string.split("\n");
   for(i=0; i<arr.length ; i++){
     var taskCI = new GlideRecord("task_ci");
     taskCI.initialize();
     taskCI.task = current.sys_id;
     var str = arr[i].toString();
     var len = str.length();
     var newStr = str.substring(0,len-2);
     var grA = new GlideRecord("cmdb_ci");
     grA.addQuery("name",'STARTSWITH',newStr);
     grA.query();
     if(grA.next()){
       taskCI.ci_item = grA.sys_id;
       taskCI.insert();
     }
     else {
       gs.addInfoMessage(" There is no CI by the name:"+arr[i]);
     }
   }
   action.setRedirectURL(current);
}
else{
   gs.addInfoMessage("You haven't attached any file by the name UploadCI.csv");
   action.setRedirectURL(current);
}
```








