---
layout: post
title: "Ruby is too slow for programming competitions"
date: 2013-04-21 12:59
comments: false
---


_Update 1: a number of people over at Hacker News [have pointed out major inefficenies in my solution,
and various better ways of solving this](https://news.ycombinator.com/item?id=5585590). At this point,
I think it's fair to say the tldr; is that while my bad solution
was prohibitevly slow in Ruby, Go could run it with ease.
If you are like me and don't always come up with the best solutions,
you may want to consider other languages for these kinds of situations too._

_Update 2: I had originally assumed I had a bug in my solution that was
causing the Go program to have the incorrect output, but a Hacker News
commenter [pointed out that it was probably the integer type](https://news.ycombinator.com/item?id=5586152) I was using. 
The version of go I was originally running, 1.0.3, defaults integers to
32 bit, whereas version 1.1 and above defaults to 64 bit.
After updating my version of Go, this program generates the correct
output, but now takes about 2 minutes and 47 seconds to run. Not as
compelling an arument as before, but well within the limits required._

----


This past weekend, I participated in the qualification round of Google
Code Jam 2013. It was year is my third time participating, and the third
time that I have used Ruby as my primary language.

Since I have no prior experience in actually being _competitive_ in
programming competitions and I use Ruby at my day job (it's one of the
that drew me there), I'd never given my language
choice much of a second thought. Sure, I knew Ruby wasn't going to be
__zomg fast__, but I always assumed that if I chose the right solution and
wrote in an efficient manner (memoizing, storing values/lookups that
would be used later, limiting search spaces, etc), my ability to 
write code quickly and concisely mattered  more than sheer processing speed.

I was wrong. 

<!--more-->

[Problem C of the 2013 qualification round](https://code.google.com/codejam/contest/2270488/dashboard#s=p2)
was called 'Fair and Square', and can be simplified as such:

    Given two numbers X and Y, return how many numbers in that range
    (inclusive) are palindromes, and also the square of a palindrome.

This seemed pretty straight forward. Obviously, I was going to need a
function to determine if a given number was a palindrome, so I
benchmarked a method that determined by converting to a string, and one
that used 'math', because I heard computers do that really fast.

    Rehearsal -------------------------------------------------------------
    Integer palindrome method   7.700000   0.000000   7.700000 (  7.705190)
    String palindrome method    4.890000   0.010000   4.900000 (  4.907374)
    --------------------------------------------------- total: 12.600000sec

                                    user     system      total        real
    Integer palindrome method   7.770000   0.000000   7.770000 (  7.773088)
    String palindrome method    4.720000   0.010000   4.730000 (  4.726223)

*[Source code for this benchmark](https://gist.github.com/clifff/5401367)*

I'd been burned in the past in Code Jam problems by manipulating strings
when I could have been doing math, so this was a little surprising to me.
But hey, numbers don't lie, and I know I need to be writing efficient
Ruby, so this is good to know.

In short order, I had a Ruby program that passed the sample input, as
well as the small input.

{% highlight ruby %}
def string_palindrome?(num)
  s = num.to_s
  s == s.reverse
end

ARGF.readline
count = 0
ARGF.each do |input|
  count += 1
  found = 0
  start, finish = input.split(" ").map(&:to_i)
  sqrt_start = Math.sqrt(start).to_i
  sqrt_finish = Math.sqrt(finish).to_i
  (sqrt_start..sqrt_finish).each do |x|
    if string_palindrome?(x)
      square = x ** 2
      if string_palindrome?(square) && (start..finish).cover?(square)
        found += 1
      end
    end
  end
  puts "Case ##{count}: #{found}"
end
{% endhighlight %}

I figured that this had a good chance of working. I knew I'd chosen the
faster of two options for checking palindromes, and that looking at
the square root of the range boundaries cut the search space down a lot.

The first large input for this problem consisted of 10000 test cases
with a range of 1 to 10<sup>14</sup> ([file here](https://gist.github.com/clifff/5430194)).
Code Jam requires you run the input and upload the correct output within 
8 minutes - it took my implementation 53 minutes to run. 

This was pretty surprising to me, so lets dig into why. A ruby-prof
output of a partial run of the input:

     %self      total      self      wait     child     calls  name
     49.89   1549.912   984.824     0.000   565.087 326068740   Object#string_palindrome?
     21.47   1974.150   423.798     0.000  1550.352      499   Range#each
     16.34    322.536   322.536     0.000     0.000 326069738   Fixnum#to_s
     12.29    242.552   242.552     0.000     0.000 326068740   String#reverse
      0.02      0.409     0.409     0.000     0.000   557447   Fixnum#**

~50% of execution time spent in `string_palindrome?` isn't great, but
makes sense. At least we know it would be worst with `integer_palindrome?`?
Much more troubling is that `Range#each` is 21.47% of the execution time.
Extrapolating a bit, that means that from the original runtime  of 50
minutes, 10.5 minutes was spent incrementing numbers. There's no
way this is possible, right? Sanity check time, and I'll even optimize a
little by not using Range:

{% highlight ruby %}
file = File.new(ARGV[0], "r")
file.gets
count = 0
while (input = file.gets)
  start, finish = input.split(" ").map(&:to_i)
  sqrt_start = Math.sqrt(start).to_i
  sqrt_finish = Math.sqrt(finish).to_i
  x = sqrt_start
  while(x <= sqrt_finish) do
    x += 1
  end
end
{% endhighlight %}

And the output...

    real  5m42.952s
    user  5m42.787s
    sys   0m0.153s

Welp. Five and a half minutes, just to iterate numbers we need.
Presumably, almost all of time is just spend incrementing and comparing
integers. There should be no GC, but maybe [Fixnum to Bignum promotion is
afoot](http://blog.headius.com/2012/10/so-you-want-to-optimize-ruby.html).

Obviously, something had to change, so I tried rewriting the program in
Go (more on that experience at a later date).

{% highlight ruby %}
package main

import (
  "fmt"
  "math"
)

func palindrome(num int) bool {
  var n, reverse, dig int
  n = num
  reverse = 0
  for (num > 0){
    dig = num % 10
    reverse = reverse * 10 + dig
    num = num / 10
  }
  return n == reverse
}

func main() {
  var cases int
  fmt.Scan(&cases)
  for i := 0; i < cases; i++ {
    var found, start, finish, sqrt_start, sqrt_finish, square int
    fmt.Scan(&start, &finish)
    sqrt_start = int(math.Sqrt(float64(start)))
    sqrt_finish = int(math.Sqrt(float64(finish)))
    for j := sqrt_start; j <= sqrt_finish; j++ {
      if palindrome(j){
        square = j*j
        if palindrome(square) && square >= start && square <= finish {
          found += 1
        }
      }
    }
    fmt.Print("Case #", (i + 1), ": ", found, "\n")
  }
}
{% endhighlight %}

While I haven't gotten around to making the output of this pass the
problem, it's doing the same thing as the Ruby version, except it is
FAST.

    real  0m0.740s
    user  0m0.482s
    sys   0m0.189s

I've always known that as an interpreted language Ruby was going to be
behind on the performance curve, but I am surprised that something so
simple as iterating over an integer range could take minutes. In the
future, I'll pass on Ruby for time sensitive programming competitions. 
