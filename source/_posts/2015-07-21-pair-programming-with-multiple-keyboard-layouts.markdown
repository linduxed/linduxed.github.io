---
layout: post
title: "Pair programming with multiple keyboard layouts"
date: 2015-07-21 03:10:33 +0200
comments: true
categories: linux
---

I enjoy pair programming: I find it's a way to both solve problems quicker and exchange knowledge easier.
With that said, due to my habit of extensively [customizing my environment][dotfiles], there's a fair chance that my computer will be borderline unusable for other people.
A year or two ago I was forced to solve a couple of aspects of this problem, to enable my colleagues to pair program with me on my computer.

  [dotfiles]: https://github.com/linduxed/dotfiles

Let's tackle the one of those hurdles:

You and your pairing partner use different keyboard layouts.

<!--more-->

## Prerequisites

I'm making the assumption that these apply to you:

* You use Linux.
* You pair program by having two keyboards.
* You have a second keyboard of a different brand/model than the primary keyboard.
* You *don't* use a desktop environment that completely overrides Xorg keyboard configuration (an example would be Gnome).

If any of these don't apply to you, then I don't think the contents of this blog post will work for you.

## Setting things up

We'll be doing three things:

1. Figuring out what the vendor name and device name are for your second keyboard.
2. Writing some Xorg configuration.
3. Restarting Xorg a couple of times because getting Xorg files right the first time is impossible.

### Vendor and product

If the secondary keyboard is connected by USB (as most are these days), plug it in and run `lsusb`. This should result in a list like this:

```
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 005: ID 8087:0a2a Intel Corp.
Bus 001 Device 010: ID 03eb:8b06 Atmel Corp.
Bus 001 Device 003: ID 064e:9700 Suyin Corp. Asus Integrated Webcam
Bus 001 Device 016: ID 04d9:2013 Holtek Semiconductor, Inc. Keyboard [Das Keyboard]
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

This particular output is what I get when running `lsusb` on my laptop with my Das Keyboard plugged in.
You're interested in stuff after the colon-separated hexadecimal values, the vendor and product *names*.
Since the two names are concatenated, it might sometimes be hard to figure out where the vendor name stops.
For this, run `lsusb -v`.
In my case, I'd be looking for the last two lines in this output:

```
Bus 001 Device 016: ID 04d9:2013 Holtek Semiconductor, Inc. Keyboard [Das Keyboard]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x04d9 Holtek Semiconductor, Inc.
  idProduct          0x2013 Keyboard [Das Keyboard]
```

You can also just run `lsusb -v | grep -e idVendor -e idProduct`, since you already know what you're looking for.

As a side-note, if you're running Arch you can find all the "named" vendor-product combinations in `/usr/share/hwdata/usb.ids` (for other distributions, it should be called `usb.ids` too, so just `find` for that).

### Writing the Xorg configuration

While these will be Arch-specific instructions, I expect the location of the files to be basically the same across most distributions.
I'm sure you'll figure it out.

In the `/etc/X11/xorg.conf.d/` directory you might find a bunch of files called `XX-something.conf`, where `XX` is a number.
The lower the number, the higher the priority.
You'll have to read through the other files present in this directory to determine what number you should use for your keyboard configuration.

Let's say you've got a default keyboard configuration file called `10-keyboard.conf`:

The contents of the file could be something like this:

```
Section "InputClass"
    Identifier "default-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "us,us"
    Option "XkbVariant" "colemak,"
    Option "XkbOptions" "grp:rctrl_rshift_toggle,terminate:ctrl_alt_bksp"
EndSection
```

This would by default set my keyboards to the Colemak layout, with the option of switching to the default US layout (that's what the *lack* of text after the trailing comma after `colemak` means: default variant).
Here I've also added two options: cycling between layouts (or in this case variants) and classic X termination.

Now let's add an overriding alternate configuration file for the Das Keyboard called `20-alt-keyboard.conf`:

```
Section "InputClass"
    Identifier "das-keyboard"
    MatchIsKeyboard "on"
    MatchVendor "Holtek Semiconductor, Inc.|04d9|0x04d9"
    MatchProduct "Keyboard [Das Keyboard]|2013|0x2013"
    Option "XkbLayout" "se"
EndSection
```

Notice the `|` separators on the `MatchVendor` and `MatchProduct` lines.
These allow you to not only input multiple different vendors/products to match, but also input them in either plain text form or hexadecimal form.
For the hexadecimal form, I haven't figured out whether you need the `0x` or not, so I've included both forms.

While you can match against any of the provided vendors/products, remember that if you have both the `MatchVendor` and `MatchProduct` lines, then you need to match at least one from each.

As for layout (which is why we did all of this in the first place): set the `XkbLayout` and `XkbVariant` to whatever you need.
You can find all available layouts and variants in `/usr/share/X11/xkb/symbols/`.

### Restart X

Assuming you got the Xorg configuration file right (congratulations if it worked on the first try!), then all you need to do is to restart X.

After that, just plug in the Designated Pair Programming Keyboard in and start hacking!

## Final words

As mentioned at the start, as a guy with a system that differs a lot from what most people use, fixing the keyboard layout isn't the only problem to solve.
There are other things that I need to do to facilitate efficient pair programming on my machines, but I'll get to that in a different post.
