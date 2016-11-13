---
layout: post
title: [Quick tip] - Getting the Incident number on header
--- 



 {{page.title}}
======================================================




For getting the incident number on the header, this script( i wrote a similar script long back, and so this isn't in JQuery) should get you started. My colleague on Friday had a similar requirement,so thought would post it.

The trick is just adding a td element with the class name "form_header". I am still unsure of why do "they" need this Incident Number on the header-its right in front of your eyes;at the top of the form. But anyways, here's the code.

Name: GetNumberOnHeader
Type: onLoad
<pre lang="javascript">function onLoad() {
var arr = document.getElementsByClassName('header');
var i=0;
while(arr[i]){
if(arr[i].innerHTML.indexOf('green_back.gifx')!= -1){
var tds = arr[i].cells.length;
var cell4 = arr[i].insertCell(2);
var heada = document.createElement('h2');
heada.className = "form_header";
heada.innerHTML = "<strong> --"+g_form.getValue('number')+"</strong>";
cell4.appendChild(heada);
}
i++;
}
}</pre>
Note: This is designed with Aspen's DOM structure. Modify it accordingly by inspecting the DOM using any DOM inspector like Firebug for previous releases. I am not sure of this, but vaguely recollect that the DOM structure <em>might </em>be different.

Update: The above code wasn't working properly in <span style="text-decoration: line-through;">IE</span>. So i came up with this simplified code.
<pre lang="javascript">function onLoad() {
var arr = document.getElementsByClassName('header');
var i=0;
while(arr[i]){
if(arr[i].innerHTML.indexOf('green_back.gifx')!= -1){
var a = "Incident --"+g_form.getValue('number');
var inn = arr[i].cells[1].innerHTML.replace("Incident",a);
arr[i].cells[1].innerHTML = inn;
}
i++;
}
}
</pre>

Tested in <strike>IE </strike> and works fine.