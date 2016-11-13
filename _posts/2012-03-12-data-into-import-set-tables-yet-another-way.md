---
 layout: post
title: Write data into import set tables : Yet another way !
--- 
 {{post.title}}
======================================================

Few months back, I had  to look into a functionality which will process and get the data from some client-utility that will generate dynamic xml.i.e for every call it may generate a new XML file. The XML file need not be stored anywhere in a shared location but I was asked to get that XML and process it.I finally with some manage to crack it but I wasn't satisfied.You can read the entire  post <a href="http://servicenowdiary.com/2011/11/custom-http-get-request-to-a-server/">here</a>

When I had implemented this solution I hated myself. I hated myself that I was helpless,so helpless that I am coding so irresponsibly that I am directly writing data into Service Now Tables,which should not happen.

Please,never write data from an external source directly to a Service Now table. Even if customer is okay with it. I will tell the reason for this may be in some of my future posts.

I was trying to find a way to do it through import set tables, and then have a transform map process my data that I am writing it into Import Set table.It all begins this way, I remember reading something in wiki which speaks about a synchronous Import set.

Quoting from wiki

Synchronous Mode :
<blockquote>An import set with a <em>Mode</em> of <em>Synchronous</em> will transform the data as soon as it is inserted (provided that the transform map already exists)</blockquote>
Asynchronous Mode:
<blockquote>If the associated <a title="Import Sets" href="http://wiki.service-now.com/index.php?title=Import_Sets">import set</a> mode is set to <em>Asynchronous</em>, the behavior is to save the data for transformation at a later time</blockquote>
You would want to read the entire article(though it is on a different topic) <a href="http://wiki.service-now.com/index.php?title=Web_Service_Import_Sets">here</a>

Yes. You are right, we will be using Import Set in Synchronous mode to get our Job done.

Steps to be followed :
<ol>
	<li> Custom load the data you would want to load using either Load Data or Data Source(This would create an import set table).</li>
	<li> Create a transform map on this import set table.</li>
	<li>When you were creating this Load Data - Data source  there will be an import set getting created,Go to that import set and change the state to "Synchronous".</li>
	<li>You are almost done. Now write the data from any Scheduled Job into this import set table and see what happens. The transform map runs and the data gets inserted into the Service Now table just the way you want it :)</li>
</ol>
Exactly what I wanted to do! Oh.. Now you would want to ask me.. Abhiram, Why do we need this " Yet Another way"? We already have two ways with one powerful way(Data Sources) to transform the data?

Patience folks. The next post will take you through a good way you can process files without headers and there guys, this method would come handy!

Toodles!