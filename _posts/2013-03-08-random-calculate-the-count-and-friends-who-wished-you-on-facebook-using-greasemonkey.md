---
 layout: post
title: Random : Calculate the count and friends who wished you on Facebook using GreaseMonkey
--- 
 {{post.title}}
======================================================
If you dont have Grease Monkey, then go get this here : <a href= "https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/"> Grease Monkey </a>
Install this in your Firefox, and copy this in a user script. Load the entire page on  which you want to calculate the number of birthdays and then run this User script. 

Add as much as search terms you would choose to and enjoy!


[javascript]

// ==UserScript==
// @name        Calculate No of birthday postings
// @namespace   www.servicenowdiary.com
// @description It calculates the number of birthday postings
// @include     https://www.facebook.com/*
// @version     1
// @require       http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js
// ==/UserScript==

$(document).ready(function(){
var whoSaid = [];
a  = $.map($('.timelineUnitContainer'),function(a){
var isThere  = '';
var isThere = $(a).html();
isThere = isThere.toLowerCase();
if( isThere.indexOf('many many') != -1|| isThere.indexOf('happy returns') != -1 || isThere.indexOf('happy birthday')  != -1 || isThere.indexOf('birthday') != -1 || isThere.indexOf('b\'day') != -1 || isThere.indexOf('returns') != -1  || isThere.indexOf('bday') != -1){
$(a).find('.fwb').each(function(){
if($(this).parent().attr('class') == 'fcg'){
whoSaid.push($(this).find('a').html());
}
})}});
if(whoSaid.length != 0){
alert('on this page, there are ' + whoSaid.length +' wishes');
alert('These are the ones who wished you! - Thank them ! \n' +whoSaid.join('\n'));
}

});

[/javascript]