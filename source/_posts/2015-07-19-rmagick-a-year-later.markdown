---
layout: post
title: "RMagick - A year later"
date: 2015-07-19 18:30:25 +0200
comments: true
categories: tech
---
Just a few days short of a year ago, I explained [the sorry state of RMagick development][last-year-post] and claimed the following:

  [last-year-post]: /blog/2014/07/25/the-state-of-rmagick-development

{% blockquote %}
RMagick isn’t going to go anywhere until a fork takes off, because the sole maintainer doesn't seem to be likely to do anything.
{% endblockquote %}

Fortunately, it did take off.

Here's a summary of what has happened during the last year.

<!--more-->

## The early days of the fork

It all started with [Benjamin Fleischer](https://github.com/bf4) getting tired of how thoroughly orphaned the project was.
He happened to be the creator of the [Gem Home Github group](https://github.com/gemhome), a place where orphaned gems could *maybe* have their development picked up by a new maintainer.

He made [this post](https://github.com/rmagick-temp/rmagick/issues/18#issuecomment-50022523).

Issues imported and a few volunteers ready to pitch in, all set to continue on his fork, right?
Remember, however, that there were plenty of forks of RMagick.
Due to the glacial pace of development on the main repository, people forked RMagick left and right to make their minor fixes.
That, or they orphaned RMagick altogether, if they could.

The thing that turned it into "The one true fork" was when, just four days after forking, Fleischer announced that [he had obtained push access][push-access-post] on Rubygems for the `rmagick` gem.
Versions [`2.13.3-rc1`][rc1] and [`2.13.3`][point3] came just a few days after.

  [push-access-post]: https://github.com/rmagick-temp/rmagick/issues/18#issuecomment-50288329
  [rc1]: https://rubygems.org/gems/rmagick/versions/2.13.3.rc1
  [point3]: https://rubygems.org/gems/rmagick/versions/2.13.3

## Work continues

Things started off slow but steady: some discussion about code style, going trough old issues that were no longer relevant and starting new issues for all the various failing test cases.

Soon enough we started to get new contributors and development once again picked up its pace.
With [Ilia Vassilevsky][vassilevsky] emerging as a stalwart core maintainer of the project, and with contributors like [Robert Fletcher](mockdeep) and [u338steven](u338steven) joining after hearing news about the fork, it became clear that the project once more had a future.

At the time of writing, since the fork started the repository has grown by 295 commits, attracted 18 new contributors and [has opened 101 new issues][issue-search] (excluding the imported ones from the old repository).

  [vassilevsky]: https://github.com/rmagick/rmagick/commits?author=vassilevsky
  [mockdeep]: https://github.com/rmagick/rmagick/commits?author=mockdeep
  [u338steven]: https://github.com/rmagick/rmagick/commits?author=u338steven
  [issue-search]: https://github.com/search?o=asc&q=rmagick+repo%3Armagick%2Frmagick+created%3A%3E2014-07-25&ref=searchresults&s=created&type=Issues&utf8=%E2%9C%93

However there was one thing left, one thing that was left itching.
Very recently the work in the fork was vindicated:

## Transfer of repository

For most of the fork's life, despite [Fleischer][bf4] contacting Github, we had to live with the fact that `https://github.com/rmagick/rmagick` pointed to a repository that was as dead as they get.
We had to occasionally head over to the old repository's issue tracker and tell people to submit their issues and contribute over at the fork.

[Early June this all changed.][repo-move]

The old repository has been moved to [https://github.com/rmagick-temp/rmagick][rmagick-temp] and the fork has been moved to [https://github.com/rmagick/rmagick][rmagick-main]!

  [bf4]: https://github.com/bf4
  [rmagick-temp]: https://github.com/rmagick-temp/rmagick
  [rmagick-main]: https://github.com/rmagick/rmagick/
  [repo-move]: https://github.com/rmagick/rmagick/issues/205

## A project revived

It started with one guy getting tired of seeing yet another widely used gem getting orphaned.

A bunch of people came together, took up the torch and eventually took over the name of the project.

Looking upon this past year, I wish some other orphaned projects would enjoy this kind of revival.
