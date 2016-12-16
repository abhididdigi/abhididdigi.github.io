---
layout: post
title: Issue with OOB Workday Integration
---

{{page.title}}
===============

This is a rant. You wouldn't probably learn anything from this post. I'm right now going through the Workday OOB integration, and this post is a list of issues in the design of Workday Integration.

Because there is a _lot_ of development that went into the Integration, I'll first talk about some good things:

1. Fairly easy to extend by writing your own extensions by modifying the Factory.
2. Robust WD polling mechanism. Never had problems with _fetching_ the data from Workday.


Things that may need to improve:

1. No way to customize the mapping between the User Table/HR profile table and the WD data.
	This means that there is no way I can add any more fields/delete fields control mapping using data except by writing code after extending the `workday_worker_retriever class`. 
	
2. There are just too many updates everywhere. For example, the Transform Map is already on `HR Profile`. Then, in the `workday_worker_retriever` class, there is the following code:

	```
	/**
		 * If profile already exists with same first name, last name and
		 * personal email combination, then update the user for the profile
		**/
		var profile = this.getProfile(source);
		if (profile) {
			profile.employee_number = source.wd_employee_id;
			profile.update();
			this.updateUser(source, profile.user);
			target.user = profile.user;
			if (source.wd_terminated == "1" && source.wd_end_date < this.getTodayDate())
				this.terminateSysUser(target);
			return;
		}
	```
	
	God.
		