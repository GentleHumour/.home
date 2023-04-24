#!/bin/bash
#------------------------------------------------------------------------------
# Configure Gnome shell extensions.
#
# Some extensions are installed as system packages. The rest are installed by
# this scipt.
#------------------------------------------------------------------------------

pip3 install gnome-extensions-cli

#------------------------------------------------------------------------------
# Locally installed user extensions.
#
# The gnome-extensions-app package includes both a GUI and the gnome-extensions
# command line app. However, the latter is fairly inconvenient for installing
# extensions, since it requires a ZIP archive. The Python gnome-extensions-cli
# (a.k.a. gext) command line app will install extensions by their ID
# (name@email).
#
# gext install <id> shows a Yes/No prompt GUI dialog. The only
# way to avoid that, according to the readme on github
# (https://github.com/essembeh/gnome-extensions-cli) is to use the filesystem
# backend (-F/--filesystem), which may not install some extensions properly.
#
# Note: you can reorder the extensions by enabling and disabling them, with the
# most recently enabled one appearing furthest to the left in the right display
# area of the panel.
#
# Interesting extensions:
#  * Caffeine: https://extensions.gnome.org/extension/517/caffeine/
#    * Currently installed as package.
#  * Material Shell: https://extensions.gnome.org/extension/3357/material-shell/
#    * Interesting, but somewhat confusing.

# Clipboard History: https://extensions.gnome.org/extension/4839/clipboard-history/
# Pano would be a fancier alternative: https://extensions.gnome.org/extension/5278/pano/
gext -F install clipboard-history@alexsaveau.dev

# Dash to Panel: https://extensions.gnome.org/extension/1160/dash-to-panel/
# * Allows control of major top level panel elements and spacing/padding.
# * Better than using Launcher to run scripts: https://extensions.gnome.org/extension/1160/dash-to-panel/
# * Has the edge over App Icons Taskbar, but can't desaturate icons:
#   https://extensions.gnome.org/extension/1160/dash-to-panel/
gext -F install dash-to-panel@jderose9.github.com

# Desktop Clock: https://extensions.gnome.org/extension/5156/desktop-clock/
# * Good example for implementing Conky alternative ("Desktop Web View").
gext -F install azclock@azclock.gitlab.com

# Desktop Cube: https://extensions.gnome.org/extension/4648/desktop-cube/
# * Like Compiz, but no way to rotate with Unite and Desktop Icons instealled.

# Desktop Icons: https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/
gext -F install ding@rastersoft.com

# Easy Screencast: https://extensions.gnome.org/extension/690/easyscreencast/
gext -F install EasyScreenCast@iacopodeenosee.gmail.com

# Extension List: https://extensions.gnome.org/extension/3088/extension-list/
#gext -F install extension-list@tu.berry
echo "Please install Extension List through the GNOME website: https://extensions.gnome.org/extension/3088/extension-list/."

# Logo Menu: https://extensions.gnome.org/extension/4451/logo-menu/
# * Distro logo and drop down menu on the panel.
gext -F install logomenu@aryan_k

# Show Desktop Button: https://extensions.gnome.org/extension/1194/show-desktop-button/
gext -F install show-desktop-button@amivaleo

# Todo.txt: https://extensions.gnome.org/extension/570/todotxt/
gext -F install todo.txt@bart.libert.gmail.com

# Unite: https://extensions.gnome.org/extension/1287/unite/
gext -F install unite@hardpixel.eu

# Vitals: https://extensions.gnome.org/extension/1460/vitals/
# * More info and better customisation than Simple System Monitor: 
#   https://extensions.gnome.org/extension/4506/simple-system-monitor/
# * Padding/spacing adjusted by CSS? https://github.com/corecoding/Vitals/pull/111/files
# * Currently no way to reorder displays? Seems he wants to parse /etc/sensors3.conf in a
#   future version: https://github.com/corecoding/Vitals/issues/324
# * Note: items are ordered according to when they were added, left to right:
#   https://github.com/corecoding/Vitals/issues/93
gext -F install Vitals@CoreCoding.com

# Workspace Indicator: https://extensions.gnome.org/extension/21/workspace-indicator/
# * Beware the inferior extension of the same name.
gext -F install workspace-indicator@gnome-shell-extensions.gcampax.github.com

#------------------------------------------------------------------------------
# Restore extension settings from backups.

restore-dconf.sh
