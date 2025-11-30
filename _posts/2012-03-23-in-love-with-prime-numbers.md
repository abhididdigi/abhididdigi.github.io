---
layout: post
title: In Love with Prime Numbers !
---



 {{page.title}}
======================================================




They are just beautiful. I never knew they were so good. Always lurking in the dark as if they are good-for-nothing, can't-be-divisible-divided alien beings in the world of Mathamatics.

While recently solving some problems on <a href="http://www.projecteuler.net" target="_blank">projecteuler.net</a>, which is partial towards Prime Numbers, I fell in love with these aliens. Watch the blog for more, but today i will be posting a  Java Program which gives you an array list of any magnitude of Prime Numbers taking the least time.Its the least anyone can simplify it. The program is written in Java also it gives the execution time in milliseconds.

Note: You will have to pass the upper limit and the program gives the prime numbers between [0- upperlimie]. I haven't used any iterator,you can use it as well for formatting your output.

```java
import java.util.*;
class ReturnPrime {
public ArrayList primeArr;
public long num;
ReturnPrime(long num){
primeArr = new ArrayList();
this.num = num;
addPrime(this.num);
}
public boolean isPrime(long num){
if(num == 1){
return false;
}
else if(num %2 == 0){
return false;
}
else if(num% 3 == 0){
return false;
}
else if(num < 9){
return true;
}
else {
long r =(long) Math.floor(Math.sqrt(num));
/* This is to check only the numbers that are greater than or equal to SQRT of num. This
is because,If you don't find any number in this range that divides the given number,its definately prime*/
/* There is no chance that the root getting divisable by 2,without the number itself getting divisable by 2,3.*/
/*  The fact that any prime number greater than 3 can be written in the following format 6K(+-)1*/
long _start = 5;
while(_start <= r){
if(num%_start == 0) return false;
if(num%(_start+2) == 0) return false;
_start = _start + 6;
}
return true;
}

}

public void addPrime(long num){
for(long i=1; i<=num; i++){
if(isPrime(i)){
primeArr.add(i);
}
}
}
/* This will return the entire ArrayList.You will have to use Iterator to Parse it*/
public ArrayList returnPrim(){
return primeArr;
}
/* This will return the Prime at a specific Location, say 30th prime*/
public long getLocPrime(int index){
Long l =  (long)primeArr.get(index);
long _l = l.longValue();
return _l;
}
public static void main(String [] args){
long startTime = System.currentTimeMillis();
long l = (long)Long.parseLong(args[0]);
ReturnPrime rp = new ReturnPrime(l);

ArrayList al = rp.returnPrim();
System.out.println(al);
long stopTime = System.currentTimeMillis();
      long elapsedTime = stopTime - startTime;
      System.out.println("Elapsed time in Milliseconds:"+elapsedTime);

}
}
```

Written using notepad++ you would want to try it as well. Its a light-weight editor.
