---
layout: post
title: Export an entire record/variables of a table, and save them as attachments.
tag: servicenow
---

In this post we will see how to export a record to xml , Variables of Requested item to a XML and attach it to the same record. I will be using a UI action for the same, but feel free to use this Server Side code anywhere.

**Exporting an entire record into XML and attaching it**

```javascript
var xml = '<xml>';
var fields =  current.getFields();


for (var i = 0; i < fields.size(); i++) {
	var columnName = fields.get(i);
	xml = xml+templateXML(columnName.getLabel(),columnName.getDisplayValue())



}

xml = xml+'</xml>';
var attachment = new Attachment();
var attachmentRec = attachment.write('sc_req_item', current.sys_id, ('sc_req_item'+current.sys_id), "text/xml", xml);
gs.addInfoMessage(attachmentRec);

function pruneString(str){
	str = str.split(' ').join('_');
	str = str.replace(/\?/g,'')
	return str;

}

function templateXML(label,value){
	return '<'+pruneString(label)+'>'+pruneString(value)+'</'+pruneString(label)+'>';
}
```

---

**Exporting variables on requested item and storing them as Attachments**

```javascript
var xml = '';

for (i in current.variables){
    v = current.variables[i];
    displayValue = v.getGlideObject().getQuestion().getLabel();
    v = v.split(' ').join('_');
    v = v.replace(/\?/g,'')

    displayValue  = displayValue.split(' ').join('_');
    displayValue = displayValue.replace(/\?/g,'')
    xml = xml+'<'+displayValue +'>'+v+''
}
xml = xml+'';

var attachment = new Attachment();
var attachmentRec = attachment.write('sc_req_item', current.sys_id, "record.xml", "text/xml", xml);
gs.addInfoMessage(attachmentRec);
```

---

**Or finally, if you are looking for only some information to be stored, here is the code:**

```javascript
var xml = ''+
''+current.number+''+
''+current.state+''+
'';
var attachment = new Attachment();
var attachmentRec = attachment.write('incident', current.sys_id, "record.xml", "text/xml", xml);
gs.addInfoMessage('An attachment is created with sys_id and attached to this incident'+ attachmentRec);
```
