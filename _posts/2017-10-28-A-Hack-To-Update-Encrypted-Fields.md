
---

layout: post

title: A Hack To Update Encrypted Fields

---


{{page.title}}

=============================================

At the time of writing this post, ServiceNow still handles Encryption in a really not-so-good way. I'll explain, read on. 

Say you created a new Encrypted field. For the sake of brewity let's say you want to store the SSN information in ServiceNow, and SSN being a PII you created an encrypted field. This SSN however can be updated from either UI, API or Data Loads. When you are testing updating the SSN from the UI things look fine. However, you'll soon notice that you aren't able to update the SSN from API or any of the Data Sources. If the problem that I just explained sounded like the one you are facing, then this post is for you. 



### We will talk about the following below: 

1/ A short intro into Encrypted fields (not the edge encryption feature), and why they aren't getting updated from API or Data sources. 

2/ A hack, and I literally mean a hack to make the update on the encrypted fields from API or Data Sources. 



##### Encrypted fields and their context

If you haven't enabled encryption in ServiceNow, you can do so from the [Encryption Support](http://wiki.servicenow.com/index.php?title=Encryption_Support#gsc.tab=0). If the user doesn't have an encryption context, the user will not be able to see the encrypted field or update it. When you give a user an encryption context for an encrypted field, the user will be able to update that field. So when you are running a data load into ServiceNow using Data Sources and Transformation maps, the underlying user that ServiceNow uses to "transform" the data is _system_. _system_ doesn't have an encrypted context and so it will not be able to update any of the encrypted fields. You should be able to update the encrypted field through API, if the user who you are authenticating with does have the context of the Encrypted field you are trying to update. However if you are using a public endpoint (or) if the user doesn't have the encrypted context, then, API will not be able to update the encrypted field. 



##### Solution

![example][https://raw.githubusercontent.com/abhididdigi/abhididdigi.github.io/master/_images/10_29_17%2C%2015_00%20Office%20Lens.jpg]



