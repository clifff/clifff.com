---
layout: post
title: "Google Code Jam 2012"
date: 2012-05-09 22:54
comments: true
---

This past weekend, I competed in Round 1 of Google Code Jam, a competitive programming competition.
Although it was my second time participating in GCJ, things didn't
really go much better than last year.
It should be noted I used the same [tools I created last year](/blog/2011/05/22/learning-from-my-first-google-code-jam/) to
test solutions, which was very helpful.

I'll talk a little about each round/problem to the best of my
recollection, and as always, my (attempted) solutions can be found on
GitHub [here](https://github.com/clifff/Google-Code-Jam/).

<!--more-->

## Qualification Round

This year's competition kind of snuck up on me, so I jumped straight into
the qualification round one Saturday afternoon. I managed to get 45 out
of 100 points in about 3 hours, which I felt pretty decent about since
only 20 were needed to qualify for Round 1.

'Speaking in Tounges' problem was particularly fun/easy since it was
just a simple substitution cypher, but I've written a couple programs to
break this before so it was no problem.

'Dancing with Googlers' ended up being longer than most of my solutions,
and was a bit tricky. It seems that many GCJ problems give the impression of
impossibly large search/solution spaces, but there are one or two
facets of the problem that limit it. In this problem, it was the fact
that scores could only differ by two points.

My solution for 'Recycled Numbers' only passed the small input, since it
timed out on the large. I suspect I did a poor job limiting the search
space here.

## Round 1B

Before this round, I did four or so practice problems throughout the
week to be prepared. Apparently that was nowhere near enough preparation,
because I got demolished this round with a grand total of 0 points.

Honestly, I was never able to figure out anything resembling a good
solution for 'Saftey in Numbers'. Every scheme I devised for
equally disturbing points worked on the small sample sets I had, but failed on
real data.

'Equal sums' was just as bad. To me this seemed just like the NP
complete problem of the [subset sum problem](https://en.wikipedia.org/wiki/Subset_sum_problem) and I was unable to figure out the problem differed in a leveragable manner.
Another example not being able to identify the key factor that makes the
problem simpler than it seems.

## Round 1C

Given how bad 1B went, I was determined to be up at 4 AM on a Sunday to
try again for Round 1C. Fortunately, this round went slightly better,
getting a total of 28 points, which was only 10 points short of
qualifying for Round 2.

'Diamond Inhertience' was pretty straight forward and I managed to solve
the small and large inputs. It was a nice touch that this is a classic
computer science / compiler problem.

'Out of Gas' was the other problem I attempted, and frankly, had no idea
how to even address. All the rules of determining where the car should
be made sense, but I think I just had trouble articulating those rules
into code in an accurate manner. Specifically, I had trouble figuring
out all the possible intersections given the way that the lead car
changed speed.

I'd like to imagine in a less sleep deprived time, I'd be able to solve
'Out of Gas', but this time, it was too much for me.

## Conclusions

In general, I was disappointed in my performance this year. I was hoping
to squeak into Round 2, but was unable to do so. I do think I did a
better job with testing my solutions as I went (yay Test::Unit!) and
writing better, cleaner Ruby. However, I still fundamentally lack the
experience to break down these problems into smarter, manageable
chunks, specifically where math was involved.

I think in certain problems like 'Out of Gas', I had issues with the
math as well. Not that I don't understand it (at least, my engineering
degree suggests I probably understand), but I'm no longer able to solve these
kinds of things like I used to since I'm out of practice.

I'm still glad I took the time to freshen up on some of
these skills I don't always use in day to day programming on the job,
and look forward to trying to do better next year.
