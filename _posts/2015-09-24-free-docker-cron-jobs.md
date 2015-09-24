--- 
layout: post
title: Free Docker Cron Jobs! Buy now!
published: true
---

<img src='http://i.imgur.com/bJaRHgE.jpg' alt='The Disintegration of the Persistence of Memory' style='width:100%'>
_Salvidor Dali's "The Disintegration of the Persistence of Memory"_

I recently took a little time to learn the basics of
[Ansible](https://serversforhackers.com/an-ansible-tutorial) so that my
personal VPS is managed a little better.
All this server really does right now is running a cron job to build and update this site.

clifff.com is a static site built on Jekyll and hosted on S3 ([source is here](https://github.com/clifff/clifff.com)), but I like to
update the ["What I'm Reading" section](/reeder/) frequently to keep the
content fresh.
I've configured a Docker container in the repo for this site, so
building and updating the source files on S3 it is as easy as `docker run`.
[I have a cron job that does this hourly now](https://github.com/clifff/ansible/blob/master/roles/cron/tasks/main.yml).

I really like this setup - since the blog setup is containerized, all
my VPS does is run it like any other executible. Server setup is trivial.
The downside is, my cheap little VPS is sitting around doing nothing most of
the time. I loath inefficeny, so let's do something about this.

_I'll run your Docker containers on a cron schedule for free._

Maybe you also want to build and push out updates to your static site,
maybe you want to scrape something hourly,
maybe you have way cooler ideas than I can imagine. I hope so.

Obviously, there are no gurantees here. I'll do my best to keep things
running, but this is just a fun little experiment.

Here's how it goes: <a href='mailto:clifreeder+dockercron@gmail.com'>Email me</a> with a
link to your Docker Hub image, and let me know what it does, and if it
needs any ENV variables passed in.

And that's it. Hope to hear from you!
