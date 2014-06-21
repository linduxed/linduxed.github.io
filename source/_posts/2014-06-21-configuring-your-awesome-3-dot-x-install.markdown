---
layout: post
title: "Configuring your Awesome 3.x install"
date: Mon, 15 Jun 2009 00:59:35 +0000
comments: true
categories: tutorial
---
After posting my guide on installing Awesome 3.x I got the inevitable question
of how to actually configure it. This WM is not for the faint of heart.  
On the other hand it does offer a lot of customization, should you know the lua
programming language. I for one don't, but that didn't stop me from tweaking
the defaults, and for most people that will be enough to get them started.

<!--more-->

As soon as one starts to see the possibilities offered by Awesome, very soon
the `#awesome@irc.oftc.net` channel will have a new visitor.

## Startup applications

The first thing to adjust is to get your startup applications going. I'm using
Ubuntu right now, so the locations of the files will vary from distro to distro,
but the content that I will outline will not.  
The thing to look up is the `xsession` file that that your desktop manager uses
to execute `awesome` after login. For me the file lies here:

    /usr/share/xsessions/awesome.desktop

This file looked like this in it's original state for me:

```
[Desktop Entry]
Encoding=UTF-8
Name=awesome
Comment=Highly configurable framework window manager
TryExec=awesome
Exec=awesome
```

For configuration purposes, I changed this to the following:

```
[Desktop Entry]
Encoding=UTF-8
Name=Awesome
Comment=Starts Awesome 3
Exec=/usr/share/xsessions/awesome_fixed.sh
Type=Application
```

The main change is that that the `awesome_fixed.sh` file is run instead of
`awesome.` You can call the `awesome_fixed.sh` file anything, but do end it with
a `.sh` suffix.

You will now need to create the mentioned file and fill it with the wished for
applications:

    sudo vim /usr/share/xsessions/awesome_fixed.sh

My file currently looks like this:

```sh
#!/bin/bash

# Colemak necessities.
xset r 66 &
xmodmap -e "remove Lock = Caps_Lock" &

gnome-settings-daemon &

# Wallpaper switching.
habak -ms -hi /home/linduxed/Pictures/wallpapers/ &

# Tray apps.
nm-applet &
gnome-power-manager &
update-notifier &
gnome-do &
# alarm-clock &
# blueproximity &

exec /usr/bin/awesome
```

Note that all entries before the exec line need to be marked as background
processes with an ampersand (`&`).

## Configuring the WM

Most configuration of the WM itself (and also all that I have ever touched) is
done in the central `rc.lua` file:

    sudo vim /etc/xdg/awesome/rc.lua

Here you will be presented with a long file that basically decides how Awesome
will behave. There are tons of lines to configure, but the defaults are really
good so we'll focus on the critical ones to tweak.

At the time of writing my configuration file looks like [this](
https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua)
(**EDIT**: old file no longer available, this is most likely not far off). It's
designed for a colemak keyboard layout.

### The tweaks

There are bunch of tweaks that you figure out on your own, thanks to the
included comments above various configuration options, so I'll just mention
a couple of the changes. The following pieces of code are mostly excerpts from
larger blocks of code:

```lua Floating https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L319-L320 start:319
{ rule = { class = "MPlayer" },
  properties = { floating = true } },
```

Lines like these force applications to float, or (if you'd need it) the
opposite. One thing to always remember is to have all except the last line in
a list be ended with a comma, otherwise Awesome will not start at all.

```lua Desktop auto-tagging https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L327-L330 start:327
{ rule = { class = "Thunderbird" },
  properties = { tag = tags[1][8] } },
{ rule = { role = "ncmpcpp" },
  properties = { tag = tags[1][9] } },
```

If you've got an application that you always start and then move to a specific
desktop (or "give it a tag" as it's called in Awesome) then this section is for
you. Just as in the float-apps section, remember the commas!

Next up are the key bindings. I like to keep every thing centered around
a arrow-key-layout, so the most frequently used commands will be on the
QWERTY-layout keys JKLI, a bit less used ones on YHUO so that everything is
close.

```lua Cycle between desktops https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L171-L172 start:171
awful.key({ modkey, }, "l", awful.tag.viewprev ),
awful.key({ modkey, }, "y", awful.tag.viewnext ),
```

```lua Cycle between windows https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L175-L184 start:175
awful.key({ modkey, }, "i",
    function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey, }, "n",
    function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
```

```lua Move the windows around https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L189-L190 start:189
awful.key({ modkey, "Shift" }, "i", function () awful.client.swap.byidx( 1) end),
awful.key({ modkey, "Shift" }, "n", function () awful.client.swap.byidx( -1) end),
```

```lua Switch which screen is focused https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L191-L192 start:191
awful.key({ modkey, "Control" }, "i", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "n", function () awful.screen.focus_relative(-1) end),
```

```lua Jump to client with urgent-flag https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L186 start:186
awful.key({ modkey,  }, "u", awful.client.urgent.jumpto),
```

Some applications can send urgent-flags (IMs for instance), this jumps to them
(regardless of what tag is currently up).

```lua Move delimiter https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L206-L207 start:206
awful.key({ modkey, }, "u", function () awful.tag.incmwfact( 0.05) end),
awful.key({ modkey, }, "e", function () awful.tag.incmwfact(-0.05) end),
```

In a lot of its layouts, Awesome splits the desktop into two halves, with
a delimiter in the middle. Make sure to place this on easily accessible keys,
because it's often used.

```lua Adjust window count https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L208-L209 start:208
awful.key({ modkey, "Shift" }, "u", function () awful.tag.incnmaster( 1) end),
awful.key({ modkey, "Shift" }, "e", function () awful.tag.incnmaster(-1) end),
```

Where in the previous snippet we moved the delimiter, this adjusts the amount
of windows on the main side of the delimiter. Hard to explain, easy to grasp
once you use it. Keep this easily accessible too.

```lua Adjust column count https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L210-L211 start:210
awful.key({ modkey, "Control" }, "u", function () awful.tag.incncol( 1) end),
awful.key({ modkey, "Control" }, "e", function () awful.tag.incncol(-1) end),
```

Same as previous, but increases/decreases amount of columns (that's what the
config file calls them) on the secondary side of the delimiter. Again, try it
out to understand what I'm talking about.

```lua Fullscreen https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L228 start:228
awful.key({ modkey, }, "f", function (c) c.fullscreen = not c.fullscreen end),
```

```lua Kill application https://github.com/linduxed/dotfiles/blob/0033a11d10560fa78acd10569316a6aabdad9075/.config/awesome/rc.lua#L229 start:229
awful.key({ modkey, }, "`", function (c) c:kill() end),
```

## Conclusion

So those are the basics. I will most likely post follow-ups on this HOWTO when
I find some new tricks that make using Awesome even better. I've barely
scratched the surface, so if someone has some hacks that they'd like to share
I'd be glad to post them here.
