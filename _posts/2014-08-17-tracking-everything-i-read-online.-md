--- 
layout: post
title: Tracking everything I read online
published: true
---

## What?

One month ago today, I started keeping track of [everything I read online](/reeder/).
Right now it's just a reverse cron list with titles, links and the
occasional note.
There are a little more than 400 things recorded so far, which isn't a
lot, but I think it's a pretty interesting data set and I'm excited for what
can be done with it in the future.

I should clarify: this isn't _everything_ I've read, but it is most
things. This is strictly opt-in data collection, so I have to add each
item manually.
Any article or page with actual content that I read more than
half of, I add to the list. Admittedly, I tend to not log things
like Hacker News comments, Imgur, programming documentation or '31 dog gifs you have to see'.

## Why?

For the last eight years, I've been using Last.fm to log [what music I
listen to](http://www.last.fm/user/Clifff), and I've become 
pretty attached to that data.
It's a lot of fun to look back each year at what [new music I've found](https://clifff.com/blog/2013/01/21/side-project-albums-of-2012/),
or what I was [listening to this week three years ago](http://backtracks.co/).

I listen to a lot of music, and I also spend a lot of time reading things online.
In the far future, I want to be able to look back and see what I was reading during certain
times of my life, or when big things happen in the world.

Advertising trackers, Google, my ISP, probably the NSA, all have databases of what I read online
- and yet I don't.
This is data _about me_ that I would find personally valuable, that
other people have and I don't.
Since they aren't going to share it, I'm compiling it myself.

Making this data public (even in a controlled, censored format) 
gives me a feeling of control, and it also forces me to think about _what_ I'm
reading. 
More practically, it also means I have an easy place to look up
articles or things I know I've read but want to check before referencing
in conversation.

## How?

This project was actually kick started by reading pinboard.io's
[fifth birthday blog post](https://blog.pinboard.in/2014/07/pinboard_turns_five/).
I wasn't familiar with Pinboard before, but I realized it had all the
functionality to make bookmarking
everything I wanted very easy - and it even had unread and note
distinctions I knew I would make use of.
The Pinboard API has a 'return all bookmarks' endpoint too, which really speaks to their dedication to users owning their own data.

Whenever I finish reading something online, I use either the Pinboard
Chrome extension or Android app to add it as bookmark.
Since this blog is powered by Jekyll, I wrote a little Rake task that
pulls down my Pinboard data, and converts it into [Jekyll data file](http://jekyllrb.com/docs/datafiles/):

{% highlight ruby %}
require 'rubygems'
require 'bundler'
require 'faraday'
require 'json'

task :update_read do
  puts "Starting update_read task"
  conn = Faraday.new("https://api.pinboard.in")
  resp = conn.get("/v1/posts/all", {
    'auth_token' => ENV['PINBOARD_API_KEY'],
    'format' => 'json' 
  })
  json = JSON.parse(resp.body)
  data_dir = "_data"
  FileUtils.mkdir(data_dir) unless Dir.exists?(data_dir)
  File.open("_data/read.json", 'w'){ |file| file.write(JSON.dump(json)) }
  puts "update_read complete!"
end
{% endhighlight %}

I have Jekyll page that [converts that data file into an HTML page](https://github.com/clifff/clifff.com/blob/5471f6b386539b46877f63788c8b21f00852f245/read.html),
and VPS has a cron job to run `rake update_read` and rebuild the site
and deploy it once an hour.
Paginating the data page would be nice but Jekyll [doesn't seem to support it](https://github.com/jekyll/jekyll/issues/1820).

After building this and showing some coworkers, one pointed out that
[reading.am](https://www.reading.am/) does this just about the exact
same thing - so if you want to try this to, check it out.

For the full source of my approach, see the [Github repo for clifff.com](https://github.com/clifff/clifff.com).
