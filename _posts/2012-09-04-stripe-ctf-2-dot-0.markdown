---
layout: post
title: "Stripe CTF 2.0"
date: 2012-09-04 21:11
comments: true
---

![Stripe CTF Logo](http://i.imgur.com/GisRf.png)

Last week, I participated in the [Stripe CTF 2.0 challenge](https://stripe.com/blog/capture-the-flag-20),
which focused on web application vulnerabilities.
It was my first time participating in a CTF event, and Stripe made the event fun,
and relatively accessible, but still challenging.
With a bit of determination and help from irc, I'm happy to say [I made it through all eight levels](https://stripe-ctf.com/progress/clifff).

I was originally planning on writing up a short explanation of each level and how I solved it,
but [several](http://blog.matthewdfuller.com/2012/08/stripe-capture-flag-level-by-level.html) 
[extensive walkthroughs](http://blog.ioactive.com/2012/08/stripe-ctf-20-write-up.html)
have already been posted, so I'm not really inclined to do that.

Instead, I figured I'd highlight a few of the things I learned through the event.

<!--more-->

_Note:_ I had some prior experience with 
[exploiting common web vulnerabilities from a course](https://www.eecs.umich.edu/courses/eecs398.f09/tempprojects/398-f09-proj2-spec.3.pdf)
I took while at University of Michigan, which gave me a good understanding of things
that were guaranteed to show up, like SQL Injection, XSS and CSRF.

### SQL Injection via UNION

Level 3's application only allowed you to execute a SQL command, so things like injecting a 
complete command errored out. However, I learned that by [injecting a UNION statement](http://hakipedia.com/index.php/SQL_Injection#UNION_Statements)
you can effectively insert and return a totally arbitrary query, all in one statement. 

### HTTP Only Cookies

When first attacking Level 6, I had thought it required stealing the session cookie
from another user. After a lot of poking and prodding and confusion why I couldn't
read the session cookie from JavaScript, I learned about [HTTPOnly cookies](http://en.wikipedia.org/wiki/HTTP_cookie#Secure_and_HttpOnly).
By prohibiting them from being read by JavaScript, and instead only by the HTTP protocol, these cookies
are protected the very kind of XSS attack I was attempting.

### String.fromCharCode

Level 6 featured various other forms of XSS protection, such as preventing writing any strings into
the database that contained quotes. To get around this, I was tipped off to the
[String.fromCharCode](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/String/fromCharCode)
method, which allows you to convert a string back and forth between a set of numbers.

All the more reason to use proper sanitization libraries instead of rolling our own.

### Hash length extension attacks

Solving level 7 required forging an API request for a credentialed user, which was possible
since a signed request was left out in the open. I read a number of sites explaining
why this attack was possible, and I found
[Nicolas Felix's article on exploting SHA1](http://journal.batard.info/post/2011/03/04/exploiting-sha-1-signed-messages)
to be the most informative on WHY the attack works, and 
[VN Security's SHA1 padding attack](http://www.vnsecurity.net/2010/03/codegate_challenge15_sha1_padding_attack/)
post to be more informative on HOW to execute the attack.

### Python

I attempted to write the solution to level 8 first in Bash, then Ruby, and finally, in Python.
Having never written Python before, I chose it because the machine the program had to run on
was fairly locked down in terms of installing new programs, but the expansive built in library
for Python had all of the pieces I needed to use.

I can't say that I have any strong feelings about it from such small exposure,
but it did match my expectations of not being too different from Ruby.
The whitespace rules were a little annoying, but I can imagine getting used to them.
The standard docs/lib were nice, but I hard time figuring out what packages were really called
when importing versus Googling (not that Ruby gem's don't have that problem too).

In the future, I'll have to try it again.
