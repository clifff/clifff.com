---
layout: post
title: "Leaving Janus for Vim"
date: 2012-07-08 13:24
comments: true
---

Although I had experimented with Vim in college, I didn't start using it seriously until about two years ago.
I was writing one off Ruby scripts and attempting to learn Rails at the time, and primarily working in Ubuntu.
I didn't use much in the way of plugins since I was just editing a single files or small projects that I wrote all of.

When I started working at Vox Media in January 2011, I switched over to the dark side (OSX), but wanted to keep using Vim.
One of my coworkers showed me [Janus](https://github.com/carlhuda/janus/) - a highly customed Vim distribution,
"designed to provide minimal working environment using the most popular plug-ins and the most common mappings."
Since these plugins seemed useful for the large codebase I would be working in, I started using it.

Janus did deliver in providing a lot of plugins that I found very useful, and it worked great for me for a long time.
I'm extremely appreciative of the efforts it's authors have put into it, but I started to sense we weren't a great match.
Every day, little things about it would bug me.

<!--more-->

Whenever I tried to modify my .vimrc file, I realized I had no understanding of what all was in there.
I had tons of plugins installed (how many?) that I didn't know what they did or how to use them.
JSLint was great, but broke my Ack plugin when it searched javascript files.
Updating Janus itself was a nigthmare.

In a lot of ways, it started to feel like I needed to learn Janus just to use Vim, which just seemed wrong to me.
It was like being in a workshop full of tools, and I only knew how to use a hammer and a drill.

The list of annoyances kept building up, until I decided to just _rm -rf ~/.vim_ and start fresh.
Just like anything else, I figured building up from scratch would give me a better understanding of what was happening
than inheriting someone elses creation.

My new configuration uses [Pathogen](https://github.com/tpope/vim-pathogen/) to manage plugins, and
git for version control. This way I can add plugins at submodules, and it's easy to pull/update them when they get updated.
Having everything in git is great too, since I can revert vimrc tweaks and plugin additions easily.

Speaking of plugins, here are the ones I have settled down with:

- [Command-T for instant result-esque file opening.](https://github.com/wincent/Command-T)
- [NERDTree for all my file browsing needs.](https://github.com/scrooloose/nerdtree)
- [Ack.vim for searching files.](https://github.com/mileszs/ack.vim) Note that you probably want to setup your own .ackrc file to make sure it's behaving like you want it to.
- [Matchit so that % will go to start/end of Ruby methods and classes.](https://github.com/tsaleh/vim-matchit)
- [Vim-coffee-script for CoffeScript support](https://github.com/kchmck/vim-coffee-script)

Naturally, my setup is now [available on Github](https://github.com/clifff/dotfiles).
Future work here includes scripting the installation and upgrading of submodules, as well as clean up the rest of my dotfiles to handle private information.

While there certainly isn't anything novel about this setup, I think the switch really did improve my understanding and comfort with Vim.
I'd reccommend doing the same to anyone on the fence thinking about leaving Janus and building their own setup.
