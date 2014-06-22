---
layout: post
title: "Macros and the expression register in Vim"
date: Tue, 28 May 2013 16:30:28 +0000
comments: true
categories: linux
---
Macros and expressions are two tools that serve the purpose of saving you from
either repeating a tedious process or the time switching back and forth between
shells to run scripts to manipulate your data with. Both can be (and often are)
used separately, but can be used in tandem to do some pretty cool stuff.

So let's introduce them and see how they work.

<!--more-->

## Creating macros

Macros are series of commands that you can record by typing `q` and then some
register name. This starts a recording of user input that can then be replayed.

Let's do something simple to demonstrate:

1. `qq` starts recording into the `q` register.
2. `e` moves to the end of the word.
3. `a"` to add a quotation mark right after the word.
4. `<esc>` leave Insert-mode.
5. `b` move to the start of the word.
6. `i"` add another quotation mark.
7. `f"` jump to the second quotation mark for convenience.
8. `q` stop recording.

Yes, you probably use [vim-surround](https://github.com/tpope/vim-surround) for
this kind of thing, but this macro will allow you to surround a word with
quotation marks quickly by just pressing `@q`, and then replay the last macro
with `@@`.

## More interesting macros

While it is a simple task that you wouldn't want to repeat doing (which makes
qualify for something you should put into a macro), I'd expect myself to use
macros for bigger tasks.

Let's for instance take some CSS:

```css
#navigation li {
    display: inline;
    list-style: none;
    height: 22px;
}

#navigation li a {
    color: #ffffff;
    line-height: 22px;
    font-size: 11px;
    text-decoration: none;
    padding: 5px 15px 6px 15px;
    border-right: 1px solid #ffffff;
}

#footer {
    font-size: 11px;
    color: #aeaeae;
    width: 670px;
    margin-bottom: 20px;
}
```

This just some blocks of code from something I found on the internet. Let's
sort each block alphabetically, then join the lines in them so we get one-line
blocks.

### Rules for macro creation

The first thing you have to do when creating more complex macros is identifying
what the blocks of code your macro will manipulate have in common.

If the lines differ a lot and have little to no structure, you might only be
able to use the beginning or end of the line as a fix point. In the CSS example
above we have braces, colons and semicolons to go with. It's all about finding
those important things that your macro can hold onto, so that when you play the
macro in another place, it'll still work the same due to you fixating the
motions against a common patterns.

This means that you'll have to give the creation of macros a bit more thought
than you'd expect. Some cases are simple, where you just start the macro off by
going to the beginning of the line, but others (as we'll see) need more effort.

### The procedure

First we decide where the editing will start. This is important because if we'd
like to be able to chain together multiple executions of the macro (you might
have ten or more blocks need the same treatment), so you'll have to end the
macro by finding the same position you started from, just in the next block
you'll run the macro on.

In this case this will be the beginning of the line with the right brace. I'm
phrasing it this way because braces are easy to search for.

So position the cursor at the `#` in `#navigation li {` and let's go:

1. We start the macro by pressing `qq`.
2. Move one line down with `j`.
3. Enable Visual-line-mode with `V`.
4. We'll now search downwards to the left brace, since we know that is where
   the block ends, so `/}<cr>`.
5. This is one line too far however, so we back up one line with `k`.
6. Let's sort these lines with `:sort`.
7. This puts the cursor up at the top of the previous visual selection, so we
   move one line up with `k` to the start of the block.
8. Now we enter Visual-line-mode with `V` again and search for the left brace
   with `/}<cr>`
9. Join the lines with `J`.
10. Search for the start of the next block by typing `/{<cr>`.
11. Move to where we started, that is the beginning of the line with `0`.

By doing steps 10 and 11 you can repeat the macro for any amount of consecutive
blocks that you want to use the macro on. In this specific case we could have
skipped starting at the beginning, the right brace would have been a fine
starting position as well.  
The point is however that if you want to have a perfectly repeatable macro,
then you have to start from the same place, work with the same structure of
code and end in the same place.

Figuring out how the code you manipulate is built is the key to making macros
repeatable.

## The expression register

This register serves the purpose of entering Vimscript expressions while not
leaving Insert-mode. This can be handy if you want to incorporate some value
stored in a variable into your macros.

Let's see how it works first:

You enter Insert-mode, hit `Ctrl-R` and then `=`. This gives you a small prompt
starting with a `=`. Here you could for instance type `&et` to evaluate the
expanded tabs variable, having the expression either print `0` or `1`.

There's not much more to the procedure itself, but the expression register
depends on you being somewhat familiar with Vimscript, if you're to make
interesting stuff happen. You can read a lot more over in `:help expression`.

### Two examples

The most often demonstrated use case is basic calculation. Don't know what
`123*456+789` equals? Do this then:

1. Go into Insert-mode where you want the result to end up.
2. Hit `Ctrl-r` then `=`.
3. Write `123*456+789` then press Enter.

That's it! Another example would be to call upon a script or command with an
expression, so if you want to insert the current date you could do something
like this (when the expression register is opened):

    =system('date')

Yes, this could also be done with `:r!date` for instance, which highlights the
fact that the expression register is more suited for Vimscript expressions (as
the name implies), but it works.

## Combining the two

Since variables can be printed with the expression register, a way to use this
in macros would be to use a variable as a counter, print its value and then
increment it for each step.

Let's take this markdown text...

```
* Some
* Arbitrary
* Text
```

...and let's replace the asterisks with numbers:

1. We place the cursor at the start of the first line.
2. We set a counter variable with `:let c=1`.
3. Start recording the macro with `qq`.
4. `cl` for changing the asterisk.
5. Enter the expression register, type `c` and hit Enter.
6. Add a period to make it look nicer and leave Insert-mode.
7. Move down one line and then to the start of the line, so we start the next
   iteration from the same position.
8. Increment the counter with `:let c+=1`.
9. Close the macro with `q`.

This can now be replayed with `@q` and then `@@` across the entire list. The
main issue with this macro would be that it ends by moving down one line,
assuming that all bullet points are one line long at most.

A better solution would be to search for the next asterisk, which would
indicate a bullet point. But what if there's an asterisk in the text? Well then
we should search for a leading asterisk.

As you can see you have to adjust the precision of your movement yourself to
the use case, but that's something you'll get to explore on your own.
