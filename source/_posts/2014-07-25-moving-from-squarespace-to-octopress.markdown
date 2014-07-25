---
layout: post
title: "Moving from Squarespace to Octopress"
date: 2014-07-25 06:50:33 +0200
comments: true
categories: tech
---
Squarespace had been my blogging platform of choice for numerous years.
It looked good, had good editing features and took care of a lot of stuff for you.
However, when my posting slowed down,
I started considering whether what I was using was worth the annual bill I was paying.

I needed something that was both cheaper and that gave me a bit more control.
I was recommended Octopress by a colleague and decided to give it a spin;
I realized very quickly that this platform was a much better fit for me.

These are some thoughts I've gathered up on the subject, about a month after moving.

<!--more-->

## Squarespace, the good and the bad

I got Squarespace about four years ago and the platform has since then had a major redesign,
but overall my interaction with it didn't change much over time.

There were four things about Squarespace that I very much enjoyed:

1. A wide selection of well designed templates.
   Suitable for many different styles, it made it very easy to get up and going quickly.
   Additionally, there were plenty of easy ways to tweak the chosen design.
2. Easy-to-use tools for content creation.
   Especially after the redesign, the platform gave you a large variety of tools to build your blog posts with.
   If I wanted to create a blog post, I didn't just write a text document that I could embed some stuff in,
   rather I'd insert [content blocks][blocks] to compose my document.
   The interfaces were also nice and clean, which made editing pleasant.
3. The surrounding tools, provided by Squarespace, were of high quality.
   Whether it was the built-in analytics tools,
   the comment overview pages or the Android/iOS app they released to manage your site,
   they gave me a lot of well made tools that improved all the non-writing activities.
4. The support was remarkably good.
   Support tickets got handled quickly and getting help was always an enjoyable experience.

  [blocks]: http://help.squarespace.com/guides/what-is-a-content-block

There was an overall high level of quality that made it all very pleasant to use.

With all of that said, there were a few things which made me consider an alternative platform:

* It cost me money.
  It's not like it was a cost I couldn't handle, but why pay for something that I could make myself easily?
* It had *no* out-of-the-box tools for formatting code well.
  This is something that kept surprising me:
  there seemed to be no push towards making it easy to paste code and have it nicely rendered.  
  This is important if one of the primary things you write about is programming.
* As much as Squarespace let me configure things with its interface,
  it doesn't compare to building something on your own.  
  I build webapps for a living, so while it wasn't something that bugged me when I got Squarespace,
  today not having access to the internals is something that frustrates me.

## Along comes Octopress

As mentioned previously, a colleague of mine recommended me to have a look at Octopress.
While I had ideas for other frameworks I could use, this one stood out to me because of the following:

* Free hosting on Github Pages.
* It gives you something working right away.
* They call it the "hacker's blogging platform" and it did look kind of exciting.
* Static page generation from nothing but text documents? Yes, please.

I decided to try it before I'd consider going for some other alternatives and I must say I'm very happy with my decision.

Octopress is based on Jekyll which is a static page generator that I've heard good things about.
It's built in Ruby, which is a big plus for me considering it's my primary programming language,
and it's actively being developed.

## Setup and configuration

Getting Octopress up and running locally was very straight-forward:
```plain Setup http://octopress.org/docs/setup/
git clone git://github.com/imathis/octopress.git octopress
cd octopress
bundle install
bundle exec rake install
```
This installs the default theme and let's you start a local server:

    bundle exec rake preview

This fires up a local server on `localhost:4000` where you can see the site.
There's nothing on it at the moment, but you already have a working environment.
Almost all the non-styling related configuration is done [in the `_config.yml` file][config],
which is well documented and includes everything from page title to plugin configuration.

  [config]: https://github.com/imathis/octopress/blob/master/_config.yml

Configuration for getting the site up and running on Github Pages is rather straightforward as well.
Without going into too much detail (instructions can be found [in the Octopress documentation][github-pages]), you only need to do two things:

  [github-pages]: http://octopress.org/docs/deploying/github/

1. Push your Octopress code into a repository named `your-github-username.github.io`.
2. Run the following commands:

```plain Github deployment http://octopress.org/docs/deploying/github/
bundle exec rake setup_github_pages
bundle exec rake generate
bundle exec rake deploy
```

There are more details to it (especially if you want to have a custom domain), but in general it's a pleasantly quick process.

## Content creation

Blog posts and pages are created by invoking a `rake` task:

    bundle exec rake new_post["The title of the blog post"]
    bundle exec rake new_page["The title of the new page"]

Both of these commands generate markdown files in the `source` directory with some header data at the top, leaving the rest for you to fill out with your text editor of choice.

If you've ever written Github markdown, then you know more or less what to expect:
the support for code blocks and monospaced words is there, along with some other cool stuff which can be read about in the documentation.
This includes things like pull quotes, inline gists and captioned images.

Above mentioned `rake preview` allows you to view your changes rendered in your browser.
For extra fanciness you should try [hooking it up][livereload-op] to [LiveReload](http://livereload.com/).

As a side note: while I haven't installed many of them myself, there is a wealth of [themes][themes] and [plugins][plugins] with which you can improve your Octopress experience.

  [livereload-op]: http://erikzaadi.com/2012/09/16/using-live-reload-with-octopress/
  [themes]: https://github.com/imathis/octopress/wiki/3rd-Party-Octopress-Themes
  [plugins]: https://github.com/imathis/octopress/wiki/3rd-party-plugins

### Deployment

Once you're done writing your post/page all you need to do (assuming you're done setting up your remote, be it Github pages, Heroku or something else),
then you all you need to run is the following command:

    bundle exec rake deploy

This will generate all the necessary files in the `_deploy` directory and will push the contents of it as a commit into the `master` branch,
making it work as the deployment branch.

## The hiccups

While I've been happy with the platform in general and I don't see myself switching any time soon, there have been a couple of points of frustration.

### Styling

After having installed an alternative theme (in my opinion the default leaves a lot to be desired) I needed to do some tweaking.
Octopress provides you with a `sass/custom` directory with files where you have some commented out code for easy tweaking of the basic values like colors and fonts.
This in itself works for minor changes, but I felt that I needed to dig a bit deeper to get what I wanted.

Editing typography turned out to be more than just changing things in the `sass/base/typography.scss` file;
I had to dig around in the source, turning dials here and there, reloading the page and hoping that the thing that I just edited was the one that did the change I wanted.

Normally I don't work with front-end, and maybe the way the style code is set up in Octopress is totally fine if you'd ask a designer, but my impression was that parts of it could have been written in a way that necessitated less digging around.

There were some other minor things that I could say about the style code, but in general I'd just recommend (if you're just starting out) using one of the themes and try working your way towards what you want from there.

### Updating

Rebasing your tweaked fork of Octopress on top of `upstream/master` shouldn't be a big deal, for me the changes were almost without any conflicts.

On the other hand, the platform provides two commands which serve the purpose of applying the upstream changes to your modified code:

    bundle exec rake update_source
    bundle exec rake update_style

Depending on how much you've changed yourself or any theme that you applied changed for you, you're likely to bump into a serious `git diff` which you'll need to wade through to figure out what should go in and what shouldn't.

I ended up opting for not using these commands because everything already works for me and I also think it applies some changes that are only relevant if you use the default theme.

Additionally, there was a recent (at the time of writing) change which moves Octopress from Jekyll 1.x to 2.x, which will probably cause some headaches if you're using certain plugins. I know I had that kind of problem, so while I test some alternative plugins providing the same functionality, I'll be staying on a bit older code.

## Summary

Despite the hiccups, I feel that this platform makes blogging very comfortable and for anyone who wants something fairly simple but still capable, this platform is a solid choice.

Recommended.
