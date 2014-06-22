---
layout: post
title: "Not ready for the switch"
date: Thu, 10 May 2012 12:12:25 +0000
comments: true
categories: [gnu/linux, tech]
---
Yesterday, for some unknown reason, [Pentadactyl](
http://5digits.org/pentadactyl/) decided that it didn't want to work any more.
I still have no idea why, and since I've been suspending my computer for quite
a few days now, it might actually have to do with me upgrading Firefox from 11
to 12 quite recently. The problem was actually pretty easily solved by
downloading the latest nightly and just fire that up, but before I did that, the
sudden loss of Vim-style navigation inspired me to pick up an old project of
mine:

Moving from Firefox to uzbl.

<!--more-->

## It sounds so beautiful

For those who don't know what [uzbl](http://www.uzbl.org/) is, it's basically
a browser that adheres to the UNIX philosophy of "doing one thing and doing it
well". What that means is that the browser is split up into small pieces; you
have `uzbl-core` which is not much more than Webkit with some interfaces on top
of it, and the actual thing that resembles a browser is either `uzbl-browser` or
`uzbl-tabbed`.  
You know you're in for a ride if the developers initially didn't have
`uzbl-tabbed` at all since "window managers should be handling the different
instances of the browser, not the browser itself". All the basic functionality
that one takes for granted in other browsers that aren't strictly browsing are
extras here; bookmarks, downloading, completion and other functionality that you
come to expect are scripts that are loaded by the main configuration file.

## But the beauty comes at a price

If the application is nice then I'm willing to put the time into configuring it.
Whether it's my ZSH terminal, Vim, Firefox or something else, I'll put in the
work to get it *just right* if I know that I can get that magnificent end result
that I envision. uzbl sounds fantastic because I like the notion of being able
to configure a system from the ground up, to see what happens and to know what
does what.

There's just one big problem however:

The work necessary to get uzbl to the state my Firefox is in with the numerous
extensions and custom configurations would take *ages*, if at all possible.
I decided that I can try to live without NoScript, BetterPrivacy, Firebug and
some other nice extensions, as long as I get what I consider to be core
functionality to work smoothly. Even this (what I would consider modest)
aspiration is a challenge to say the least.

The default configuration gives you Vim-like control, with hjkl-movement and
some other things that you might recognize if you're coming from
Pentadactyl/Vimperator, but the similarities end fairly quickly. Once the basic
keys were reconfigured to my liking, one of the first things I wanted to tweak
was that since I use `uzbl_tabbed`, I'll want to reconfigure the `NEW_WINDOW`
action to load links in new tabs. The fact that only the action `NEW_TAB` worked
and not the other two potentially nice ones (`NEW_BG_TAB` and `NEW_BG_TAB_NEXT`)
was a shame, doubly so when there's no information for how get it to work.

## You're on your own

This was the first encounter (out of many, I might add) with what eventually led
me to give up on the browser. There's no comprehensive source of information
about uzbl… anywhere.

I use Archlinux on my main computer but I know that I might not have been if it
wasn't for the fantastic Wiki. I don't know if that huge source of information
has spoiled me, but I feel like I'm done with the days of guessing myself forth
when configuring software. I don't enjoy being in the situation of “Well I'd
really like to do foobar, so I guess I'll scour tens of config files to see if
someone has done something remotely similar from which I can extrapolate some
kind of solution”.

*I'm done with that shit.*

The Arch Wiki proves that even if you put docstrings for every line in your
configuration, a Wiki page with some quick and helpful tweaks that every new
user would make, is a thousand times better. As soon as I got any idea on how
I'd like to tweak the interface of uzbl, it was followed by the realization that
there's neither a quick nor an obvious way to do it.

The [official Wiki](http://www.uzbl.org/wiki/) is so barren that it seems to be
made by and exclusively for the current/future developers. Google isn't much
more helpful, the usual searches for HOWTOs or tutorials yield not much more
information than what one would derive from the sample configs that one can find
in the Wiki.

## See you some other time

The impression I get is that if you're not ready to figure it out, then you
shouldn't even start. I gave it quite a few hours and at a certain point decided
that fixing Pentadactyl would be far more beneficial and far less time
consuming.

Some day I'll probably give it another shot, but by that time I'll probably come
prepared with far more patience and without the expectation to actually replace
Firefox.
