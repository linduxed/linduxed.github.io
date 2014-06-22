---
layout: post
title: "Vim plugins - Why, How and Which"
date: Sat, 13 Apr 2013 21:12:33 +0000
comments: true
categories: [gnu/linux, tech]
---
A lot of times when I meet "Vim neophytes" they mention that Vim is a great
editor, but they miss certain features that they find in their previous
editor/IDE of choice. Often this will be a case of them not having learnt the
Vim way of doing the same task, but occasionally you'll have to tell them that
"Vim doesn't do that".  
Indeed, these days if you don't want to hop between different applications (all
of them having the primary purpose of editing text of some kind) you'll want
features that go beyond "editing text".

#### These days an editor can't just be an editor.

<!--more-->

I've met programmers who say that they're fine with using Eclipse for Java, Vim
for Ruby and then nano for minor edits in configuration files. Any workflow like
this makes no sense to me, since I wouldn't want to edit text in anything that
isn't Vim. Most people don't see how it could be any different...

...until you show them the wealth of plugins available.

## How to get them installed

The classic way of installing plugins is to get the latest version from
[vim.org's scripts](http://www.vim.org/scripts/index.php) page in the form of an
archive and just extract the contents into `~/.vim/`.

Now that you know about how it was done once upon a time, please refrain from
ever using this method (unless you want a spectacular mess inside your
Vim-directory).

These days people have plugins in separate directories, all of them stored in
some central plugin directory (most often `~/vim/bundle`). These plugin
directories are in turn loaded by some "plugin handler", of which there are
many.

A lengthy list of handlers [can be found here](
http://vim-scripts.org/vim/tools.html). It doesn't matter that much which one
you choose, but it might be a good idea to go with one of the more popular ones,
which are Pathogen, Vundle and VAM (vim-addon-manager).

## My setup

I prefer to do the handling and updating of plugins outside of Vim, so I've got
the following setup:

I've got a "dotfiles" git-repository to which I've added my Vim-plugins as
submodules. This allows me to update all my plugins (along with any other
git-repos I've added as dotfiles) with one command (alias it to something
shorter):

    git submodule foreach git pull origin master

Committing these updated plugins with `git commit -a` and pushing the dotfiles
repo will then allow me to clone the repo anywhere and get all my plugins at the
same time (just make sure to clone with the `--recursive` flag).

Standing in `~`, adding the plugins would be done with a command like this:

    git submodule add git://github.com/linduxed/vim-linduxed-theme.git .vim/bundle/vim-linduxed-theme

I then use Pathogen to load all the plugins (read its FAQ about adding it as
a submodule, if that interests you).

I should also mention that while not necessary, structuring up your `~/.vimrc`
somewhat could be of great help, since it will increase in size after you start
adding plugins. `:set foldmethod=marker` and [adding some markers](
https://github.com/linduxed/dotfiles/blob/master/.vimrc) helps a lot.

If you don't already have a `.vimrc`, this is a [good starting point](
https://github.com/tpope/vim-sensible).

## Which plugins do I get?

There are quite a few plugins out there, so I'll just get you started with those
that I find most significantly improve my Vim experience. Click on the plugin
names to be taken to their respective repositories.

If you're hungry for more after going through this list, check out
[the other plugins I've got in my setup](
https://github.com/linduxed/dotfiles/tree/master/.vim/bundle) and go to
[Vim Scripts](http://vim-scripts.org/) or [the official script page](
http://www.vim.org/scripts/index.php).

### File and buffer navigation

#### [CTRLP](https://github.com/kien/ctrlp.vim/)

There are a few fuzzy-search plugins out there, the most well known ones being
[Command-T](https://github.com/wincent/Command-T), [FuzzyFinder](
https://bitbucket.org/ns9tks/vim-fuzzyfinder/) and CTRLP. While they're all
pretty similar when it comes to finding files, I like CTRLP a bit more because
it lets you fuzzy find among buffers and most-recently-used files as well.

As long as you know the name of the file you're looking for, this type of plugin
takes care of most file opening operations, due to it being so quick.

In case you haven't seen fuzzy-finders before, here's a quick demonstration. This is what it looks like when I look for `game/ai/ai_dropnodes.c` in the [Warsow](
http://www.warsow.net/) source code:

{% imgcap /images/blog/ctrlp.gif CTRLP in action. Looking for `ai_dropnodes.c`. %}

#### [buffet](https://github.com/sandeepcr529/Buffet.vim)

There's a lot of overlap between CTRLP's buffer switching functionality and the
functionality of buffet, but if you want a tool that does nothing but switch
between buffers swiftly, this plugin is probably it.

#### [nerdtree](https://github.com/scrooloose/nerdtree.git)

While I'm using it less and less due to CTRLP, nerdtree is still the easiest way
to explore your filesystem without exiting Vim.

### Code writing helpers

#### [vim-easymotion](https://github.com/Lokaltog/vim-easymotion.git)

The big one. This plugin changed the way I move around in code completely. While
Vim gives you a great set of tools to move around in code (one of the things
that take the longest to master), this plugin takes it to another level. It's
probably the closest thing to mouse cursor accuracy you can get, while not
wasting time to fetch the mouse itself.

Words don't do this justice, so here's a video:

{% youtube Dmv6-dguS3g %}

#### [vim-surround](https://github.com/tpope/vim-surround)

Makes the task of surrounding text with quotes, parentheses, brackets, etc. much
easier. Also provides quick removal and changing of surrounding characters.

#### [vim-snipmate](https://github.com/garbas/vim-snipmate.git)

If you haven't used an editor with snippets before, it's basically a set of
templates, small pieces of code which are often used in which you fill out the
relevant fields.

{% youtube xV2IsE5OHd4 %}

I should mention that at the time of writing the linked project has its
development slowed down, with another project called [UltiSnips](
https://github.com/SirVer/ultisnips) getting a lot of traction (along with
a [fork](https://github.com/MarcWeber/ultisnips/) made by an ex-snipmate
developer).

The situation is a bit complicated, but at the moment snipmate works fine for me
so I don't see a reason to switch.

#### [nerdcommenter](https://github.com/scrooloose/nerdcommenter.git)

Indispensable plugin that makes the creation and handling of comments in code
a breeze.

#### [auto-pairs](https://github.com/jiangmiao/auto-pairs)

Inserts a closing parenthesis, bracket, curly brace or quote when you insert an
opening one. Also knows what to do with braces if you press enter inside them
(indentation and new empty line between them) along with some other nice things.

There's also [AutoClose](https://github.com/Townk/vim-autoclose) which does
pretty much the same thing.

#### [tabular](https://github.com/godlygeek/tabular.git)

For the people who like their code pretty (I obsess over that kind of stuff)
this plugin aligns code.

{% imgcap /images/blog/tabular.gif Tabular lining stuff up. %}

### Miscellaneous

#### [vim-linduxed-theme](https://github.com/linduxed/vim-linduxed-theme.git)

This is here for two reasons:

1. Plugging your own stuff is always nice.
2. People should get any theme.

Seriously, the stock themes aren't that pretty and the ones you can find on the
internet are both varied and beautiful (not to mention that some have more
detailed syntax highlighting).

Here's a list of repos to look through (there are many others):

* [Vividchalk](https://github.com/tpope/vim-vividchalk)
* [Dayle Rees' color scheme collection](
  https://github.com/daylerees/colour-schemes)
* [Solarized](https://github.com/altercation/solarized)
* [Tomorrow](https://github.com/chriskempson/tomorrow-theme)

#### [gundo.vim](https://github.com/sjl/gundo.vim.git)

Many people aren't even aware of the fact that Vim has a branching undo history,
but this plugin makes it accessible. It upgrades the undo-tree from "never use
it" to "use it all the time".

#### [vim-fugitive](https://github.com/tpope/vim-fugitive)

{% blockquote Tim Pope %}
I'm not going to lie to you; fugitive.vim may very well be the best Git wrapper of all time.
{% endblockquote %}

I'll have to agree. The extensive functionality is covered in detailed by Drew
Neil in his Vimcasts videos, starting at [episode #31](
http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/).

If I was to pick just one of the many great features this plugin provides, then
it's the ability to open up the index version of the files and edit that while
having the version from the working directory open. This is like a superior
version of `git add --patch`, which is reason enough to get this.

#### [syntastic](https://github.com/scrooloose/syntastic)

This plugin runs your code through a linter or syntax checker upon every save
and loads the warnings/errors into the location list and displays markers in the
gutter to indicate on what rows the warnings/errors are.

Incredibly helpful, you wouldn't know how much until you've tried it. Syntastic
has code ready for the major linters/checkers/compilers for most languages.

Here's me fixing some warnings that pylint gives about "no space after comma"
(pylint warns about non-compliance with [PEP8](
http://www.python.org/dev/peps/pep-0008/)):

{% imgcap /images/blog/syntastic.gif Syntastic giving warnings with the help of pylint. %}

#### [vim-unimpaired](https://github.com/tpope/vim-unimpaired)

Gives you a set of very useful bindings.

## Only the beginning

The big category of plugins that I've omitted is language/framework specific
plugins. I've got a lot of those, but each specific one might not be useful to
everyone. With that said, there are some language specific plugins that are
really powerful and should most definitely be used if they align with what
you're coding in ([`rails.vim` by Tim Pope](https://github.com/tpope/vim-rails)
is, from what I've heard, considered to be a major source of Vim converts from
TextMate).

Once you start customizing your Vim, you'll notice that there are many areas
which you can improve with a plugin here and there. Just remember to stop and
consider if the functionality you're looking for isn't already available in
stock Vim.

As mentioned before, if you need some inspiration you can check out
[the plugins I use](
https://github.com/linduxed/dotfiles/tree/master/.vim/bundle) and if you've got
any problems, just fire up your IRC client of choice and head over to
`#vim@freenode.org`.
