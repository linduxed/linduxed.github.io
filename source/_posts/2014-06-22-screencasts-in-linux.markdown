---
layout: post
title: "Screencasts in Linux"
date: Sun, 08 Sep 2013 14:42:54 +0000
comments: true
categories: linux
---
Some time ago I wrote a rant about the
[sorry state of streaming on Linux](
/blog/2012/03/15/when-the-tools-just-dont-work/). About a month ago I needed to
find an application which would record my desktop for a screencast, giving me
a perfect opportunity to see if the situation had changed somewhat in this
field.

While streaming is still quite bad (video+audio works but there's still nothing
like [OBS](http://obsproject.com/)), desktop recording is in a better spot
since you only need the raw footage (bells and whistles can be handled
afterwards in a video editor). Although it took some searching, I actually
found something with which I can reliably record my desktop, with microphone
audio.

<!--more-->

## The bad

Before I start I'd like to say a few words about the applications I won't use.
When I was looking for a screencasting solution I had a couple of criteria:

1. There can be no dropped frames.
2. Synchronized audio recording is preferable, so I don't have to record audio separately.
3. I must be able to play the resulting video without any issues.
4. Screen number, window or screen area needs to be easy to set as a target.
5. Give me configuration options. I will need to tweak things.
6. Do not. DROP. **FRAMES**.

The vast majority of the tools available were almost immediately disqualified
since I could *never* depend on them giving me back a normal, functioning,
video. I remember plenty of errors during playback about not correctly marked
frames, warnings about bad keyframes, along with other stuff I've probably
forgotten. I was sort of amazed by how bad the results from the applications
were (not even taking into account how they handled #2 and #4), considering
I've seen many a blog recommending these tools.

By the way, this was tried on one top of the line laptop and another laptop
which I would at the very least call "powerful". There was no hardware related
reason for this to happen.

The one that was closest to passing was `recordmydesktop` (I used the front-end
`gtk-recordmydesktop`). It's got a decent amount of settings one can tweak,
covering pretty much every point except for #3. The resulting video had so many
problems that it couldn't be loaded into various tools, with `mplayer`
screaming warnings all throughout every generated video.  
That was the application that came the closest.

`kazam` broke rule #1 and had an almost total absence of configuration. I tried
`byzanz`, but it broke rule number #6. `istanbul` broke both rule #1 and #6 so
I didn't bother with it for long. All I remember about `xvidcap` was that it
didn't last long either; maybe it was that one with which the best results were
achieved by setting it to "output as folder with screenshots"...

There were a couple of others I tried, but I've forgotten the names by now.

Maybe there's a project I've missed that JustFuckingWorks™, but until
I discover that (`simplescreenrecorder` looks good, will have to try it), I'll
have to make due with good old ffmpeg.

## ffcast with ffmpeg settings

{% blockquote Wikipedia http://en.wikipedia.org/wiki/FFmpeg %}
FFmpeg is a free software project that produces libraries and programs for handling multimedia data.
{% endblockquote %}

Another way of putting it is that it's a command that lets you do almost
anything video related, as long as you know the correct parameters. While
setting `ffmpeg` up to record your screen is possible by setting geometry
options and such, the application [`ffcast`](
https://github.com/lolilolicon/FFcast2) (available in the [AUR](
https://aur.archlinux.org/packages/ffcast/) if you use Arch) lets you easily
select the desired window or screen to record. Whatever isn't area selection
functionality is covered by an `ffmpeg` command.

In a two screen setup, I'm using this command for recording my laptop screen
with the microphone for audio:

    ffcast -x 1 ffmpeg -f alsa -i pulse -vcodec libx264 -vpre libvpx-1080p out.mkv

`-x 0` chooses my laptop screen; it will probably be different for you so run
`ffcast -x list` to find out the correct screen. If you prefer to choose
a window to record use `-w` instead.

`-f alsa -i pulse` is for telling `ffmpeg` that I want to use `pulse` for input
audio. As for the `-f` flag, you need it for the `-i` flag to work, so just
consider those two as a package.

Choose whatever codec that works well, `libx264` is one.

Finally we come to the `-vpre` flag (and the output filename at the end, but
that one's obvious). This flag dictates what preset you want to use for
recording. Depending on what preset you use (or maybe you don't use any) the
quality of the video will range from artifact ridden garbage to crisp beauty.
To determine which presets you have available you need to list the contents of
the directory `/usr/share/ffmpeg`.  
Try some of these out. If none of these presets work for you then I'm sure you
can find some alternatives on the net.

## Progress!

While this solution is complicated, it works, which is something I haven't been
able to say about the other tools I've in this area. If stream overlays, scenes
and all of that stuff isn't important to your streaming, this might also be
a decent solution for Linux based streaming, although I haven't tried it myself
yet.

Now that I can record videos, I'll have to find a decent video editor...
