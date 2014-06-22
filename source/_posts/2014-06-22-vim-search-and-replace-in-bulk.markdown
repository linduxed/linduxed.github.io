---
layout: post
title: "Vim search and replace in bulk"
date: Mon, 16 Sep 2013 11:57:07 +0000
comments: true
categories: linux
---
Every once in a while you'll have some word or phrase that is present in
multiple files across your project. Finding all of instances can be done with
tools like `grep` outside of Vim. You could probably also use `sed`, `awk` or
some other tool to perform a substitution inside these files.

While there's nothing wrong with this approach, what if you wanted to do this
kind of multi-file search and replace inside Vim?

<!--more-->

The following methods are by no means the only ways of doing things, it's just
how I tend to solve this problem.

## Finding stuff

When in a terminal, if you wanted to find all instances of `FoobarQuux` in
a project, you'd probably run one of these commands:

    grep "FoobarQuux" $(git ls-files)
    git grep "FoobarQuux"
    ack "FoobarQuux"
    ag "FoobarQuux"

Let's look at alternatives.

### vimgrep

The built-in equivalent that Vim has is `vimgrep.` A search similar to the ones
above would be this:

    :vimgrep /FoobarQuux/ `git ls-files`

You'll notice a couple of things here.

First of all, the command uses slashes to encapsulate the regex and grave accents for eval. I'm pretty sure the `$()` syntax doesn't work here.

Secondly, the results aren't highlighted in the way that a regular search
performed with `/` would be. Instead, the Quickfix-list is populated with the
results and you can go through them with `:cnext` and `:cprevious` (quicker
bindings for that with [tpope's unimpaired](
https://github.com/tpope/vim-unimpaired)).

Lastly, and most importantly, you'll notice that vimgrep is *remarkably* slow.
I don't know why that is and I don't particularly care since there are
alternatives.

### ack.vim

We can speed things up by using the `ack.vim` plugin, which you can find
[over on Github](https://github.com/mileszs/ack.vim). I'm going to assume that
you've already got a preferred method of installing plugins, but in case you're
new to them, here's a [helpful Stack Overflow question](
http://stackoverflow.com/questions/4905554/managing-vim-plugins).

You'll have to install the ack package for whatever OS you use, then you'll be
able to run commands like this in Vim:

    :Ack "FoobarQuux"

This is just like running `ack FoobarQuux` from the command line, but the
results get loaded into a Quickfix-list. This time however, there's
a noticeable increase in performance.

### the_silver_searcher

Mr. ggreer once said "But who has the time?", and lo and behold,
*the_silver_searcher* was created. If you're not familiar with
[the_silver_searcher](https://github.com/ggreer/the_silver_searcher), it's
basically `ack` but even quicker. What's even nicer is that you don't need
another plugin for using it (although [you can get one](
https://github.com/rking/ag.vim)), you just change the command which `ack.vim`
runs. Add this to your `.vimrc` and you're good to go:

```vim
if executable("ag")
    let g:ackprg = 'ag --nogroup --nocolor --column'
endif
```

I like to use this solution because I've found that on distros like Debian,
`ack` is readily available in the repositories while `ag` isn't, so it's a bit
more portable.

## Replacing the stuff you've found

So now your Quickfix-list list is filled with lines that contain some word or
phrase you want to change. Here's an interesting fact for you then:

Vim has `bufdo` for running a certain command in all open buffers. It also has
`windo` for all open windows, `tabdo` for all tabs and `argdo` for all files in
the [arglist](http://vimcasts.org/episodes/meet-the-arglist/). All these
things, but no `quickfixdo`.

If `bufdo` doesn't overlap with the files you wish to perform replacements on
(it sometimes does), you can use [the following plugin](
https://github.com/nelstrom/vim-qargs) to populate the arglist with the
contents of the Quickfix-list. The creator of the plugin
[gives an example](http://stackoverflow.com/a/5686810/1106810):

    :Ack FoobarQuux
    :Qargs
    :argdo %s/FoobarQuux/Cranberries/gc
    :argdo update

That works, and lets us see every change due to the confirm flag at the end of
the third line.

But what if there was one command for doing it all?

### greplace - global search and replace

[This plugin](https://github.com/skwp/greplace.vim) is pretty old and there
might be newer alternatives, but it does what it should and that's all I need.

From the help page:

```
The following commands are provided by this plugin:

:Gsearch         Search for a given pattern in the specified
                 group of files and display the matches in
                 the replace buffer.
:Gbuffersearch   Search for a given pattern in all the buffers
                 in the Vim buffer list.
:Gargsearch      Search for a given pattern in all the files in
                 the Vim argument list.
:Gqfopen         Use the results from the quickfix list.
:Greplace        Incorporate the modifications from the
                 replace buffer into the corresponding files.
```

So if you were to do `:Gsearch` you'd get to input the regex, then input what files you wish to apply this to and then you'll get an *editable* with every found line!

When you're done editing the found line, you run `:Greplace` and then you'll get to approve each change in the actual file.

Regardless of how often this scenario pops up for you, you ought to try it to
see how nice this plugin is. I might also add that when you're in that editing
buffer, you could probably improve your experience even more by using the
`:Subvert` command from [tpope's abolish plugin](
https://github.com/tpope/vim-abolish), functionality which is explained
[in this Vimcast](
http://vimcasts.org/episodes/supercharged-substitution-with-subvert/).
