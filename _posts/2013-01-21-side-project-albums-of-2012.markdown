---
layout: post
title: "Side Project: Albums of 2012"
date: 2013-01-21 18:55
comments: true
---

<img src='http://i.imgur.com/Aq9j9vp.png' style='width:100%'>

As a music nerd, I've always enjoyed end of year 'best of' lists. They
are amusing, but are almost almost always ranked by what album is
'better' than another. Unsurprisingly, there is a lot of futzing about
what 'better' means and pressure to rank something one way because
that's what the cool kids do.

Yawn. What's more interesting to me is what people people have ACTUALLY been listening to.
Fortunately, [Last.FM](http://last.fm) keeps track of exactly that.
It's a great service, and I highly recommend it for music lovers.
(By the way, if you are a user, [you should add me me as a friend](http://www.last.fm/user/Clifff)!)

Although Last.FM will tell you [what your most listened to albums in the last year are](http://www.last.fm/user/Clifff/charts?subtype=albums), it 
doesn't exactly answer the question I have - what albums did I listen to
the most that _came out in the last year_?

<!--more-->

In December of 2010, I threw together a website ([source here](https://github.com/clifff/Last-FM-Albums-of-the-Year)) to answer this question.
My two goals for the project were to work on my JavaScript skills a bit,
and not have to pay for hosting. As such, I wrote it entirely
with client side JS ([using this Last.FM JS library](https://github.com/clifff/javascript-last.fm-api)), 
and hosted it on GitHub pages. 
You can still see the [home page](http://clifff.github.com/Last-FM-Albums-of-the-Year/), 
and what [an actual list looked like](http://clifff.github.com/Last-FM-Albums-of-the-Year/#clifff).

Naturally, opening up one of these lists is a bit slow because the
browser has lots of API calls to make to actually build the list. But
hey, it met all the requirements I set up.

For the end of 2012, I wanted to update the project, but with two
different goals: make pages load _FAST_, and make it not so ugly. The
result? [http://albumsof2012.com](http://albumsof2012.com) (hosting /
URL longevity not guaranteed).

<img src='http://i.imgur.com/fJtPBGR.jpg' style='width:100%'>
*The albumsof2012.com landing page*

This time around, I opted to make to use Rails since it's what I use at
my day job. (Although we are few versions behind there, and I figured
doing some work at HEAD would be educational). 

Most designers/developers will immediately notice that I used Twitter's excellent
[Bootstrap](http://twitter.github.com/bootstrap/) framework to make the
front end look nice. I heavily leaned on album art to make things 
pretty, which I think worked out well.

Not surprisingly, the back end is super simple. I totally skipped on
ActiveRecord/SQL persistence, and instead just used Redis to store
three things:

* Caching Last.FM API calls
* A Resque job to make all the necessary calls for a page
* A list of Last.fm users who have all of their API calls cached

When a user tries to hit their list page (with a url like [http://albumsof2012.com/lastfm/clifff](http://albumsof2012.com/lastfm/clifff)),
Rails checks Redis to see if the necessary API calls to build out their
page have been cached. At first, the answer is no, so a 'waiting' page
is immediately rendered, and a Resque job to fetch all the needed data is
queued.

<img src='http://i.imgur.com/tCOstqU.png' style='width:100%'>
*The waiting page*

This Resque job will pull a few pages of the most listened to albums by
that user in the last month, and then for every album in that list,
album info is fetched to see what it's release date was. 
Last.fm often has incorrect data on this, so the MusicBrainz API is checked as a
fall back. All of these calls are cached into Redis, and after all of
them have been made, their username is added to the list.

Meanwhile, the waiting page has been polling to see if their data is
ready yet - and once their name is in the list, the page reloads, and
their albums appear.

<img src='http://i.imgur.com/68uJ4BX.jpg' style='width:100%'>
*My page of albums from 2012. It actually scrolls down quiet a bit.*

I posted the site to Twitter, Facebook and Reddit on January 8, and got
moderate traffic throughout the day - about 1500 uniques when all was
said and done. I was just running the site off the lowest tier Linode VPS, so I
was a bit worried all day about the server keeping up - particularly,
about Redis running out memory.

<img src='http://i.imgur.com/Tgub8Wf.png' style='width:100%'>
*Slowly watching the available memory get eaten up*

In theory, as more users went to the site, more API calls would already
be cached and the memory usage wouldn't grow as fast. Not sure that
really worked out though. Fortunately, I never quiet ran out of space,
so didn't have to figure out a scheme to fix this. Regardless, I still
think Redis was a good choice because it made development/deployment
fast. 

How fast? Almost all list requests were process within 100ms. Mission
accomplished!

As always, [the source for this project is up on Github](https://github.com/clifff/albums_of_the_year).
In the future, I would like to do more work to make my Last.FM history more browseable/digestable.
Perhaps for Albums of 2013?
