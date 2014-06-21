---
layout: post
title: "When the tools just don't work"
date: Thu, 15 Mar 2012 11:38:30 +0000
comments: true
categories: [linux, tech]
---
Every once in a while you stumble on that area of software that Linux just
doesn't have covered. You might now be thinking that I'd like to talk about
audio and video editing. A fair guess, since you'll hear people talk about
these two as areas where the other platforms have significantly more
sophisticated software available. But this isn't what I'm going to talk about.

<!--more-->

You see, I've had a look at the video and audio editors out there for Linux, and
while it's generally not as good as what you'd have on OSX or Windows, there are
projects that make honest efforts to compete (Rosegarden comes to mind). I think
even the cynics can at least call the tools in these areas “rudimentary”.

“Streaming your desktop” in Linux, however, is one area you can't even fucking
call rudimentary. The appropriate description I've come up with is “technically
working with the help of wizardry”, and I'm thinking about whether that's too
generous.

## No audience

I can't say I'm particularly surprised by this situation, because apart from the
occasional recorded screen cast for some brand new package, there isn't that
much of a need, it seems. We don't have the games to stream, which I would
assume is a large part of what drives the revenue of a page like Justin.tv.

I assume most of the people who code in Linux aren't exactly eager to stream and
narrate their work, which could have been that “other area” of content that
would have driven the development of tools for streaming. I understand that the
Linux community might have less scenarios under which one would want to stream
one's desktop, but I'm still surprised by how dire the software situation is.

## The tools

From what I've gathered, the most “mature” application available for handling
the various aspects of streaming (sound, picture, overlays and so on) is
WebcamStudio, which didn't exactly work. At the best of times it was giving me
something that looked like the stream I wanted to pass on, but I never managed
to actually get any streaming site to accept the data. This completely sidesteps
the issue that is the buggy-as-fuck interface, that neither looks good nor works
well.

The most stable solution I've found, that has actually let me see my desktop on
the internet, is the combination of:

* Letting VLC capture your desktop with a wide array of flags to make sure it
  comes out right. Figuring out those was a ton of fun.
* Having a script called “jtvlc” catch the data and send it in through the
  Justin.tv API.

It's way better than nothing, but this gives me absolutely no ability to
customize the output, except choosing what part of my monitor set-up it should
grab.

## Conclusion

In a way, I hope I've missed something; I hope there's an obscure package that
simply grabs the part of the desktop you want, has a nice interface, and just
works. If that magic package exists however, then I haven't found it.

There are times when I really would have liked to share the view of one of my
screens, with some embedded microphone commentary. When the ideas pop up, I'd
like to go ahead and just try them out, but in this case, I'm completely
hindered. It might be that the process of getting these things to work under the
other systems is also a chore, but at least I've seen plenty examples of there
being an end result. That's something I've yet to see here in Linux.

