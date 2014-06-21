---
layout: post
title: "Sound in Ubuntu 9.04 on Acer Aspire 8930g"
date: Sun, 24 May 2009 16:56:20 +0000
comments: true
categories: tutorial
---
The Acer Aspire 8930g has got a sound card that has not only been unsupported
in GNU/Linux for a long time, it has also (to this day) never been a case of
having the card work out of the box in any distro.

It's basically a "Intel HD Audio Controller" and uses the ALC889 codec. Support
for this card was, according to the alsa-project.org mailing lists,
incorporated in the 1.0.16 driver, receiving updates every version since.

<!--more-->

I've experimented with various driver versions and so far I can only conclude
the following:

* The `alsa-1.0.18` driver is the first one to show any signs of working, let
  alone properly.
* Of the ones I've tried only `1.0.19` has managed to auto configure properly.

Since ALC889 is universally seen as a problematic codec, don't expect anything.
If any one of these methods work, rejoice, if they don't I can't say I'm
surprised.

## Different methods of installing

The first thing you need to do is to make sure you have the ALC889 codec:

    cat /proc/asound/card*/codec\#* | grep -i codec

If it's the correct codec it should return something like `Codec: Realtek ALC889`.
From here there are three four methods to get sound, three of which I've tried myself.
After each one, the following [surround sound testing audio file](http://www.lynnepublishing.com/surround/www_lynnemusic_com_surround_test.ac3)
can be used to check the result.

### First method: Editing the modprobe.d configuration

Make sure you have the latest stable alsa-base package, that is
1.0.18.dfsg-1ubuntu8. This should be installed with Jaunty, but to check type
the following:

    aptitude show alsa-base

This should return (amongst other information) the correct version number. If
not, run the following:

    sudo aptitude safe-upgrade

This should get you the latest stable (provided you have the main repository
enabled). With that fixed, you should edit /etc/modprobe.d/alsa-base:

    sudo vim /etc/modprobe.d/alsa-base.conf

If you don't use Vim, do. In absolute emergency `nano` may be used.
Add this to the end of the file:

```
alias snd-card-0 snd-hda-intel
options snd-hda-intel model=auto
```

A reboot should now be sufficient, if this method works for you that is.
Remember to go into `alsamixer` to unmute and pull up all the different
sliders.

As a footnote I might add that this gave me splendid sound on the left, right
and center channels. This setup is most likely enough for most people, but my
laptop is a 5.1 Dolby so I don't get the full experience. Currently, this is no
problem for me, but I know some will find this suboptimal, if this is the case,
move to the third method.

### Second method: Using the ALSA Upgrade Script

This method helped me get sound when it didn't work in Intrepid, in Jaunty this
didn't work for me.

Basically this method comes down to using a script that downloads, compiles and
installs the latest ALSA driver (at the point of writing, version `1.0.20`).  
The method has no prerequisites with regards to the installed driver, because
of the fact that it compiles and installs the old fashioned way. This also
means that the script will screw up your package manager when it comes to the
ALSA packages. Versions, dependencies and all that stuff will be configured
"outside of the system".

Basically, if it works then you won't want to upgrade anything through the
package manager; if it doesn't work the script comes with an inbuilt feature
that reverts to whatever the system looked like before installing with it. So
if you don't get sound after installing with this method, uninstall.

The script and much more thorough instructions can be found in the
[thread created by soundcheck](
http://ubuntuforums.org/showthread.php?t=1046137).

### Third method: Compiling the official Realtek Driver

This method I have not tried in Jaunty, so I can't speak from my own
experience. It has no prerequisites with regards to installed drivers and
according some googling, this method should provide the full Dolby 5.1,
including the Tuba subwoofer.  
It comes down to using the official Realtek drivers found
[here](http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=24&PFid=24&Level=4&Conn=3&DownTypeID=3&GetDown=false)
(check the "accept box", press next, and download the Linux driver on the
bottom). When the driver is downloaded and extracted, there are according to
[this bugreport](http://bugs.launchpad.net/ubuntu/+bug/218165) two ways of
installing.

The first one is basically to open the Readme.txt file and follow the Ubuntu
instructions step-by-step.

The second one is to opt for what in the Readme.txt file is described as
"recommended for Redhat and RH-derivative distributions". `cd` into the extracted
directory and type:

    sudo ./install

After completing the process, reboot, and subsequently type:

    sudo alsaconf

The only thing to do after this should be to adjust the settings in the
`alsamixer`, where after sound should be enabled on all speakers. As stated
above, I can't confirm this.

### Fourth method: The hda-verb utility

This method I see as a last resort because it results in a low volume, mono
sound, coming from only the right and left speaker. You will also have no
access to the headphone jack, nor will the microphone work.

I have no idea what the prerequisites are, but since you've installed ALSA two
to three times by now if you're at this stage, I'd guess you have all that's
needed on your system. Last time I tried this method I used Arch Linux so
I can't confirm it will work on Jaunty.

Download and extract `hda-verb-0.3.tar.gz`:

    wget ftp://ftp.suse.com/pub/people/tiwai/misc/hda-verb-0.3.tar.gz
    tar xzvf hda-verb-0.3.tar.gz

`cd` into the directory and run the following:

    ./hda-verb /dev/snd/hwC0D0 0x15 SET_EAPD_BTLENABLE 2

You might need `sudo` for that command to work. That should, after some
`alsamixer` adjustments, result in the above mentioned sub-par sound.

To make this occur on every boot you'd need to copy the `hda-verb` application
to `/usr/local/bin` and insert the following line on the bottom of
`/etc/rc.local` (but before the `exit 0` line):

```
/usr/local/bin/hda-verb /dev/snd/hwC0D0 0x15 SET_EAPD_BTLENABLE 2
```

This automation didn't work for me though, and at times the device `hwC0D0`
disappeared, making the command ineffective, forcing me to reboot if I wanted
sound.

## Concluding

By now the ALC889 has been around for a while and solutions for this codec
have become easier and easier, hopefully the guys at ALSA will soon have it
auto configure all the speakers for everyone using this laptop. If none of
these methods work for you I encourage you to google the problem, the Intel HD
Audio cards are being pushed into more and more computers, so solutions should
be aplenty.
