---
layout: post
title: The PopupOpenStandard Method and window.opener
tag: servicenow
---This week, I was working on a requirement where I needed to:

1.  Have a slush bucket on a catalog item's form that will have a list of all catalog items (from the `sc_cat_item` table), and clicking on any of the entries should take you to the catalog item form (which is a pop-up) and submitting it should create a cart item.

For this, I figured I would write a Glide window, but I wanted to do it more simply. Moreover, I needed a pop-up that is similar to the reference selection pop-up, i.e., it should disappear if you click anywhere else. I finally came up with this method—nothing written on my own, but a method from external JavaScript libraries called `popupOpenStandard`.

Also, I had to override the custom `dblclick` event of the right slush bucket so that I could write my own code. When someone double-clicks, it should open a pop-up (the usual functionality is to move the entry to the left slush bucket). The code is simple and goes something like this:

```javascript
function onLoad() {
var fe= g_form.getControl('<name_of_your_slush_variable>_select_1');
fe.ondblclick = fun;
}
function fun(){
/* The URL in there, is used to open a catalog item's form. You can pass different parameters to
the UI page,com.glideapp.servicecatalog_cat_item_view and also visible to all the
macros called within it. */
popupOpenStandard("/com.glideapp.servicecatalog_cat_item_view.do?sysparm_view=&sysparm_id=9e107d7b0a0a3cdd0018276a5e3f79c1&sysparm_cart_edit=9d3fc027ff522000ae69fb56e77efe3c&sysparm_seq=yes");
}
```

This is how you call any URL in the popOpenStandard method.

---

2.  Now that we are giving an option to fill the catalog item's form, we need to copy the price from the pop-up (which is a catalog item form in itself) to the parent form that is calling it. I did this using a global function in a UI script and calling it using the `top.window.opener.<function_name>` method.

I will post the code, as it might come in handy for people working on pop-ups. Since price is a complex thing, I will skip this for now and explain how to call the function rendered on the parent's form (the global UI script).

I created an `onSubmit()` function that runs only when the catalog item is called as a pop-up (this is another long story; I sent a parameter in the `popupOpenStandard` - `sysparm_seq`, which is again copied into a hidden variable on the UI macro `catalog_item`). In the `onSubmit`, I call the calling form's function:


function onSubmit() {
top.window.opener.funcGlobal(100);
}


The `funcGlobal` is a function defined in the UI script, with `Global` as `true`. Also, remember that you can set any variable on the form in `funcGlobal` using `g_form.setValue('variable_name', 'value')`.

Another small tip: if you have to read the price in any catalog item's client script to do some calculation, use the following script:

```javascript
function onSubmit() {
alert(gel('price_span').innerHTML);
}
```
<a href="http://servicenowdiary.com/wp-content/uploads/2012/10/blog.png"><img src="http://servicenowdiary.com/wp-content/uploads/2012/07/blog-300x160.png" alt="" title="blog" width="300" height="160" class="alignright size-medium wp-image-319" /></a>

For the entire code of `popupOpenStandard`, use any DOM inspector like Firebug.


Any suggestions or comments are welcome.






 