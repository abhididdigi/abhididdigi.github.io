---
layout: post
title: Why a Decrease in the Max Length of Any Dictionary Will Not Be Captured
tag: servicenow
---Sometimes—rarely, though—you might want to decrease the value of the `max_length` attribute of any dictionary entry. For example, there is a column called `response` in `sys_soap_message_test` which I mistakenly increased the length of. Now, the web service doesn't run. I want to get the value of this `max_length` back to its original value (to decrease it), which is not possible. If you haven't tried it, try it.

You can't decrease the value of `max_length` for any dictionary variable. A business rule will not allow this.

**Name:** `Dictionary Change Rationally`

**Description of the Business Rule:**
```javascript
 This rule prevents decreasing the max_length of a field. If it is deactivated,
 and the length of an out-of-box field is decreased, the change will
 automatically be reverted in the next upgrade. This behavior is by design.
```

If you want to decrease the length, then deactivate this business rule and modify the length.

Alternatively, if it is not so urgent, wait for the next upgrade, and it will be reset to its original value.


