---
layout: post
title: The Actual Story Behind the Rabbit and Tortoise Race
tag: algorithms
---<p>One day (one of those days when you get angry about the job you are currently in, thinking about all your friends joining other companies while you can do nothing about your current situation except think), I was thinking about this great line:</p>
<blockquote>
<p>Nidaname Pradhanamu (Telugu - a regional language of Andhra Pradesh, India)</p>
</blockquote>
<p>True Translation:</p>
<blockquote>
<p>Doing things slowly is really important.</p>
</blockquote>
<p><br/>I don’t deny the fact that it is really important to do things slowly and with such meticulous detail that no one else could do it better than you. But at the same time, you would probably want to strike <strike>slow</strike> from the adjectives used to describe the way you work in modern times, where humans are expected to work as fast as computers by alien managers (mother earth is already under attack, and I completely agree with the managers; if I were one, I would expect the same), who are again expected to work as fast as computers (even this alien land of the managers is conquered by other aliens called clients) by their alien clients.</p>
<p>Now, coming to this great story I am about to tell you. This will probably challenge your senses and, for a second, will make you think I am probably bullshitting and that I am writing this post because I have a lot of free time and nothing better to do. But please read on. There will be something interesting at the end. <img align="right" alt="cute Rabbit,Turtle" height="246" src="http://servicenowdiary.com/wp-content/uploads/2012/02/rabbit_turtle.jpg" width="359"/></p>
<p>One fine day, a tortoise and a rabbit plan to have a race. The finish line is 5 km away, and once either of them reaches it, they need to light the “Winning Lantern.” The first one to do so will be declared the winner. Let's assume that the rabbit can run twice as fast as the tortoise. I am the referee for this match, and I yell, “On your mark, get set, GO!”</p>
<p>Ah, here there is a small catch. Just before the race, the rabbit was so overconfident that it would win that it had six fine shots of tequila (it actually insisted on having another, though I had to step in and stop it from having more and saving its race day, thanks to me). The race began, and the rabbit reached the finish line pretty comfortably when the tortoise was 2.5 km away from the finish line. But the rabbit was so drunk that it did not realize it had just completed the race, thinking it had just started. It then ran another full 5 km from the start. This time, by the time it reached half the distance, our poor tortoise, being steady (as it was a teetotaler, just like me), was at the finish line, and it slowly lit the “Winning Lantern” and won the race.</p>
<p>Slow and “steady” wins the race. “Don’t Drink” is the literal meaning, and a more contextual meaning would be: if you are targeting something important in your life, don’t get carried away, whatever it is. Be steady on the racetrack, or you will be allowing people who are less competent than you to take your position and your job, and push you out. Then you can do nothing but think, “Ah, even I would have done that. I wasn’t focused enough (and, of course, other nonsensical reasons).”</p>
<p>We can use the above story to understand a way in which we can find loops in a linked list. When I first read about this method, I liked it so much that I wanted to blog about it.</p>
<p><strong>Question:</strong> Find the best way to find a loop in a singly linked list.</p>
<p><strong>Best Solution:</strong></p>
<p><strong>Time Complexity:</strong> O(n)</p>
<p>Simultaneously go through the list by ones (slow iterator) and by twos (fast iterator). If there is a loop, the fast iterator will go around that loop twice as fast as the slow iterator. The fast iterator will lap the slow iterator within a single pass through the cycle. Detecting a loop is then just a matter of detecting that the slow iterator has been lapped by the fast iterator.</p>
<pre class="prettyprint">// Best solution
function boolean hasLoop(Node startNode){
  Node slowNode = Node fastNode1 = Node fastNode2 = startNode;
  while (slowNode &amp;&amp; fastNode1 = fastNode2.next() &amp;&amp; fastNode2 = fastNode1.next()){
    if (slowNode == fastNode1 || slowNode == fastNode2) return true;
    slowNode = slowNode.next();
  }
  return false;
}<br/><br/><br/><br/> ```
<p>The solution is taken from <a href="http://ostermiller.org/find_loop_singly_linked_list.html">http://ostermiller.org/find_loop_singly_linked_list.html</a>. There is a good discussion on all the methods that can be employed for finding loops in a singly linked list.</p>
<p>Now you understand why I told you that story, don't you?</p>