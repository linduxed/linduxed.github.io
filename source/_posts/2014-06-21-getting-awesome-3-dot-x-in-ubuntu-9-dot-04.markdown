---
layout: post
title: "Getting Awesome 3.x in Ubuntu 9.04"
date: Mon, 25 May 2009 15:19:06 +0000
comments: true
categories: tutorial
---
Awesome is awesome. That simple. The 3.x series introduced a tray which removed
all hesitation and made Awesome the WM of choice for me. Unfortunately for
Ubuntu users (which for the time being includes me) the official repositories
are quite outdated:

<!--more-->

{% blockquote Ubuntu package policy http://wiki.ubuntu.com/StableReleaseUpdates %}
...

In contrast to pre-release versions, official releases of Ubuntu are subject to
much wider use, and by a different demographic of user. During development,
changes to the distribution primarily affect developers, early adopters and
other advanced users, all of whom have elected to use pre-release software at
their own risk.

Users of the official release, in contrast, expect a high degree of stability.
They use their Ubuntu system for their day-to-day work, and problems they
experience with it can be extremely disruptive. Many of them are less
experienced with Ubuntu and with Linux, and expect a reliable system which does
not require their intervention.

...
{% endblockquote %}

That in other words means that anyone suggesting the introduction of new
versions of existing packages has to pass the hurdle of "is this a stability
release or a feature release?". This is why the 3.x series, though superior in
most ways to 2.x, will wait until Karmic Koala before it will be incorporated
into Ubuntu's repositories.

With that said, there are two ways of getting Awesome 3.x installed onto
Jaunty. The first one is using a PPA and the other one is compiling from
source.

## Using a PPA

This is the easiest method, because not only does it eliminate the search for
dependencies but it is also a method that is tested to work with Jaunty (to the
extent of the PPA maintainers ability of course).

To install from the PPA you must first add it. The PPA we're going to use
belongs to [Arnaud Guignard and lies here](
https://launchpad.net/~aguignard/+archive/ppa). If you have never added a PPA
then [this YouTube video](http://www.youtube.com/watch?v=UUZOQsNo_ws) will
explain how to do it quite thoroughly; written instructions can be found
[here](http://help.launchpad.net/Packaging/PPA#Adding%20a%20PPA%20to%20your%20Ubuntu%20repositories).

After adding the repository, simply type the following command:

    sudo aptitude install awesome

This should get you at the time of writing the `3.2.1-1~ppa1` version of
Awesome. All you need to do is log out and choose Awesome as the session to use
in in your desktop manager (`gdm`, `kdm` or whatever you use).

## Compiling from git

This method I personally don't recommend, simply because using the PPA is so
much easier and it should work flawlessly. With that said, I suspect that most
people who use Awesome in Ubuntu compile it to get the latest
version, so it's by no means a bad way to do it.

A thing to take note of is that this will most likely screw up your package
manager, because we might be overwriting packages and at times installing
packages that are newer than the ones in the repositories. If at some point you
install some package that overwrite your manually installed files, tough, you
should have used the PPA.

With that out of the way, the instructions I used to install the latest
checkout are located on the [Ubuntu forums](
http://ubuntuforums.org/showthread.php?t=960841), it's basically a step by step guide.

The only thing I'd like to add is that there is a nice way of remedying at
least some of the problems associated with compiling and doing `sudo make
install`, and it's the marvelous utility called `checkinstall.` First you need
to run the following command to obtain it:

    sudo aptitude install checkinstall

After that, whenever the you are asked to do the classic `./configure && make
&& sudo make install`, substitute the `sudo make install` with `sudo
checkinstall`.

This will instead of dropping files outside of the package manager, build
a `.deb` that can then be installed (thus eliminating some problems). This
doesn't always work (for reasons I can't explain) but it is a wholesome way of
installing when it does. A more detailed guide to `checkinstall` can be found
[here](http://help.ubuntu.com/community/CheckInstall).
