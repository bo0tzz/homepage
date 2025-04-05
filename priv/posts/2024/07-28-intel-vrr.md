%{
title: "VRR for Intel iGPU on Arch Linux",
author: "bo0tzz",
description: "Enabling VRR/FreeSync for an Intel iGPU on Arch Linux running X11"
}

---

I recently upgraded to some shiny new hardware. Since I run Linux, of course this inevitably brought with it a bunch of obscure graphics setup tweaking.  
To set the scene (and to sprinkle a whole bunch of search keywords for people who need to solve the same problem), here's the hardware and issues that were involved:

- For the display, I'm using a 4k 144hz Gigabyte M28U. This supports VRR (variable refresh rate) through FreeSync, which I would like to use.
- My system is running an Intel i9-12900H (Alder Lake-H), which comes with an Iris Xe iGPU, driven by the `i915`/`modesetting` kernel driver.
- I'm running the i3 window manager with xorg/X11, on Arch Linux.

The problems I was seeing were:

1. The refresh rate was getting set at 60Hz instead of the full 144Hz.
2. VRR was not working, no matter the refresh rate.
3. I was getting pretty bad screen tearing.

The fix was surprisingly hard to find, but ended up being pretty easy to apply. The master branch of xorg/xserver includes [a merge request that adds a TearFree option](https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/1006) for the modesetting driver, so here's what I did:

1. `pacman -S xorg-server-git` to get an xserver build with the above fix in it. As pacman replaces xserver, it will flag a few conflicting packages. Make sure to choose the `-git` option each time.
2. Set the X config to enable this option as well as VRR

```bash
cat << EOF > /etc/X11/xorg.conf.d/10-tearfree.conf
Section "Device"
  Identifier "Intel Graphics"
  Driver "modesetting"
  Option "VariableRefresh" "true"
  Option "TearFree" "true"
EndSection
EOF
```

3. For good measure, automatically set the refresh rate to 144Hz on login:

```bash
cat << EOF >> ~/.xprofile
xrandr -r 144
EOF
```

4. Reboot (or `systemctl restart display-manager`).

You can test these changes (as well as diagnose the issue beforehand) with [VRRTest](https://github.com/Nixola/VRRTest).
