---
layout: post
title: How to Sort Records in Any Table
tag: servicenow
---Many a time, we want to sort the records of a table for display, supposing the user wants to see the rows of a table sorted according to a particular field.

There are a couple of ways to do it. One of them is to use a "before query" business rule. I stumbled across these business rules just a couple of days ago.

A "before query" business rule is one that runs just before the database is queried. More information on **Before Query Business Rules** can be found in these links:

<a href="http://www.servicenowguru.com/scripting/business-rules-scripting/controlling-record-access-before-query-business-rules/">Controlling Record Access with Before Query Business Rules</a>
<a href="http://www.servicenowguru.com/scripting/business-rules-scripting/fixing-before-query-business-rules-flaw/">Fixing a Before Query Business Rule Flaw</a>

But I perceive it (it's not an accurate perception, but it helps) more like this:
If I have a "before query" business rule, the code that you write will run just "after" the records are rendered. Supposing you write a sort, the records will be sorted just after they are fetched from the database.

Now, coming to the solution for sorting the records, I guess you have already figured it out.
You need to write a "before query" business rule on the table.

```javascript
current.orderBy("<columnName>")
```

I imagine there are a couple of ways to do this, like writing a ref qual or changing the view (which I haven't tested), but once I do, I will post about it.