---
layout: post
title: "The state of RMagick development"
date: 2014-07-25 04:40:18 +0200
comments: true
categories: tech
---
Yesterday [someone got fed up](https://github.com/rmagick/rmagick/issues/18#issuecomment-50022523) with the situation that the RMagick gem is in and forked the project.

Neither [is this the first time](https://github.com/rmagick/rmagick/network), nor do I know if this fork will help the project at large, but I think it's time people got to know what's going on with the project.

All of which I'm going to write might be obvious, old news or stuff people already knew in one way or another, but here it is anyway.
Here's some backstory that might answer the following question:

*"What's going on with RMagick?"*

Or rather...

*"Why is **nothing** happening with RMagick?"*

<!--more-->

#### TL;DR

RMagick isn't going to go anywhere until a fork takes off, because the sole maintainer doesn't seem to be likely to do anything.

## Some talk with the maintainer

In early September I joined a company that used RMagick for one of their projects.
As an Archlinux user, I quickly got to join the crowd who [had a certain problem with the gem](https://github.com/rmagick/rmagick/issues/18).

Nothing really happened with the issue and people were already making their own solutions to the problem, so after a while I got fed up with the situation and sent an email to the main/only maintainer, [@mmaiza](https://github.com/mmaiza).
For @mmaiza's sake, I won't post the actual email exchange between us, but I'll give you the important gist of it.
My first email basically consisted off:

*"Hey, there's a lot of things happening on the issue tracker for the project, could we figure something out to get things going again?"*

We had some brief back-and-forth and then in early November we had a talk about the state of the project.

### Skype call

The guy inherited a large amount of code that someone else wrote and didn't have the time to maintain it.
He really admired the previous guy's work and felt it was a shame if the project died.
On the other hand, he didn't want the project to move forward without assuring that a certain level of quality was maintained.

First of all he stressed that he had no intentions to move towards merging pull requests or fixing issues while the test suite had failing tests.
Both at the time of the conversation and now, the test suite has *a lot* of failing tests.

I also got the feeling (from the mail exchange and from the call) that he wasn't as interested in "distributed help" as he was in finding a successor for his position, a developer who could dedicate a lot of time to shape things up.
Neither was I qualified for such a position at the time, I felt, nor did I have the time;
I explicitly said that I was not asking for any Push access rights on the repository.

However, I did suggest that if he created a milestone on Github for fixing all of these tests, and in the milestone he wrote about his requirement for the tests to be green (and maybe update the README with some instructions on how to run them because that *does* take work), then maybe people would feel like helping out.

I was met with "Sounds like a decent plan, we'll see about getting it going."

## Radio silence

Two months went by and not much had happened.
The problem that originally brought me to the RMagick issue tracker [was fixed](https://github.com/rmagick/rmagick/pull/90) and a [license file was added](https://github.com/rmagick/rmagick/pull/78), but a new gem version was not made, the fixes only live in the `master` branch of the project.

Around New Year I sent him another message.
I reminded him that there would be great benefit to following through with that idea for creating a bug squashing milestone and communicating the state of the project.
That, and making it easier to run the tests so the project could be improved easier.

About a week after New Year I got a short mail that boiled down to "Yeah, we should get those tests green, I'll get back to you."

Unfortunately, almost seven months later, he hasn't.
I sent him a two more messages over that time, in one of them proposing that if he gave me Push access then I could take care of all the things for him, but I haven't heard from him at all since early January.

## Zombie application

I knew full well that I didn't have the time to (or a whole lot of will) to fix all the failing tests and problems that this project has.
Disregarding the fact that @mmaiza considered it to be of importance that updated versions of the gem were provided on RubyForge (which has since then [shut down](http://en.wikipedia.org/wiki/RubyForge#Shutting_Down)), I knew that if I would start a fork, people would need not only to contribute to it, but the world would need to catch on to the fact that there's a fork of the `rmagick` gem they need to use to get the latest and greatest.

I don't know if [the fork that was just made](https://github.com/gemhome/rmagick) by [@bf4](https://github.com/bf4) will gain traction or if the project will improve from here.
RMagick seems to have its detractors, with one of my developer friends summing it up as "probably the most hated gem in the ecosystem".
I don't know if that's the case, and some of the enmity is probably purely caused by [people's dislike of ImageMagick](https://twitter.com/garybernhardt/status/224329120346144769).  
Regardless, there's a lot of things that could be improved, and it's probably no small task to do so.

Salutations and good luck to those who actually attempt to fix this thing.
