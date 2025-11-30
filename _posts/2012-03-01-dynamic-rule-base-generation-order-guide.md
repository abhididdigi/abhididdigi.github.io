---
layout: post
title: Dynamic Rule Base Generation for Order Guides
tag: servicenow
---



 {{page.title}}
======================================================




A brand new theme. I really like it. If you are wondering why there is an underscore before the blog name, I would say it's mostly because I have always liked putting an underscore before defining any variables. It makes me feel more geeky.

This post will explain how you can generate a dynamic rule base for an order guide in a service catalog. Suppose you have four options in an order guide form: A, B, C, and D. You will have to map them to their respective catalog items in the rule base so that when you click on "Choose Options," you get a form with all four items (supposing you have checked all four options). Below, I will explain a way to automate the rule base using an `onSubmit` script and a script include. This process will check if the rule corresponding to a checked option is already present in the rule base, and if it is not, it will add one. Mind you, this happens for every `onSubmit` of the order guide page.

**Introduction:** The rule base for an order guide is stored in a table called `sc_cat_item_guide_items`. The condition is stored in the `condition` variable, and the variable that you are mapping in the rule base is stored in the `variable` variable.

I had the freedom of writing the `sys_ids` of the selected options because I created them myself using my own UI page. The details of what the UI page is are for another day. My `onSubmit` will write the `sys_ids` of all the selected options to a single-line text field (comma-separated). Now, from my `onSubmit`, it will call this script include, which will take the `sys_ids` and insert corresponding records into the rule base table. You can also extend this to send the variable name you are mapping in the rule base if you have many order guides and are planning to have a dynamic rule base.

Implementation:
OnSubmit Client Script on Order Guide Page. This will look more or less like this:

```javascript
function onSubmit() {
   var arr = document.getElementsByClassName("options");
/*As I mentioned earlier in the post,
this is a UI Page variable that I created.
So gave the class as option there*/
   var i=0;
   var str = new Array();
   while(arr[i]){
      if(arr[i].checked == true){
        str.push(arr[i].name);
      }
      i++;
   }
   g_form.setValue('slt_mapping_Components',str);
   var ga = new GlideAjax('OrderAI');
   ga.addParam('sysparm_name','ruleAI');
   ga.addParam('sysparm_sys_ids',g_form.getValue('slt_mapping_Components'));
   ga.getXMLWait();
   ga.getAnswer();

  }
```

This is a synchronous call to GlideAjax. I know you might be wondering why I am using a synchronous call rather than an asynchronous one. The reason is that if you use an asynchronous call and the rule base is not present, the `onSubmit` script will run (and complete) before the record gets inserted into the rule base table. Hence, the synchronous call.

Script Include:

Name: OrderAI

```javascript
var OrderAI = Class.create();
OrderAI.prototype = Object.extendsObject(AbstractAjaxProcessor,
{
   ruleAI: function()
   {
      var list=  this.getParameter('sysparm_sys_ids').split(',');

      var check=0;
      for(var i=0; i<list.length;i++){
         var gr = new GlideRecord('sc_cat_item_guide_items');
         gr.addQuery('condition','CONTAINS','IO:464317d0ff902000ae69fb56e77efe8d');
         /**********************************************************************************************
          IO:464317d0ff902000ae69fb56e77efe8d is the variable name,You can get this value either from the
         rule base table, or you can write a client script on this variable and copy the Variable column
         in the list view of a Client Script. You can as well pass this value to the script include from
         the on Submit *********************************************************************************/
         gr.query();

         while (gr.next()) {
            var con = gr.condition.toString();
            if(con.indexOf(list[i]) != -1){
               check=1;
            }

         }
         if(check == 0){
            this._ruleAI(list[i]);
         }
      }      },
      _ruleAI: function(sysID) {
         var crb = new GlideRecord("sc_cat_item_guide_items");
         crb.initialize();
         crb.item = sysID;
         var condition = "IO:464317d0ff902000ae69fb56e77efe8dLIKE"+sysID+"^EQ";
         crb.condition = condition;
         crb.guide = "873c4ed8ff502000ae69fb56e77efe5e";
         crb.insert();
         gs.addInfoMessage("New Rule Base added.");
      }});


```


**Note:** This might be a performance killer because of the heavy lifting done by `onSubmit`.

As you can see, I had hardcoded the values in the script include. You can also pass the values from the `onSubmit` script.

***Acknowledgments***:
Loyola Ignatius- For the Idea of the Dynamic Order Guide Creation.

