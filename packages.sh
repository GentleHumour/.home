#!/bin/bash
#------------------------------------------------------------------------------
# Set up my Fedora system.
#
# References:
#   [1] https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/
#   [2] https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/
#   [3] https://rpmfusion.org/Howto/NVIDIA
#   [4] https://www.hackingthehike.com/fedora38-guide/
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Log message.

log() {
  local STATUS="$1"
  printf "[%-6s]\t" "$STATUS" 
  shift
  echo "$@"
}

#------------------------------------------------------------------------------
# Log ok status with message.

ok() {
  log OK "$@"
}

#------------------------------------------------------------------------------
# Log failed status with message.

failed() {
  log FAILED "$@"
}

#------------------------------------------------------------------------------
# Print dividing line.

div() {
  echo "----------------------------------------------------------------------"
}

#------------------------------------------------------------------------------
# Wrap sudo dnf install

package() {
  local PKG="$1"
  for PKG in "$@"; do
    if rpm -q "$PKG" >&/dev/null; then
      ok already installed "$PKG"
    else
      div
      if sudo dnf install -y "$PKG"; then
        div
        ok installed "$PKG"
      else
        div
        failed installing "$PKG"
      fi
    fi
  done
  unset PKG
}

#------------------------------------------------------------------------------
# Change primary group of affected user ($1) to be "users" (usually 100).

set_group_to_users() {
  local AFFECTED="$1"
  echo "Checking primary group of $AFFECTED."

  # Does the affected user exist yet?
  local AFFECTED_ENT=$(getent passwd "$AFFECTED")
  if [ $? -eq 0 ]; then
    # Look up numeric GID of "users".
    local USERS_GID=$(getent group users | awk -F: '{ print $3; }')
    # Look up numeric GID of affected user.
    local AFFECTED_GID=$(awk <<<$AFFECTED_ENT -F: '{print $4}')
    
    if [ $AFFECTED_GID -ne $USERS_GID ]; then
      echo "Changing primary GID of $AFFECTED to $USERS_GID (users)."
      echo "This can take a few seconds as files under /home/$AFFECTED are changed."
      sudo usermod -g $USERS_GID $AFFECTED
    fi
  else
    echo "User $AFFECTED doesn't exist yet."
    echo "Run this script again when they have been created to set their primary group."
  fi
}

#------------------------------------------------------------------------------
# System updates. Get onto the latest kernel, then reboot.

sudo dnf update -y
div
echo "Do you want to continue installing packages? (y/n)"
echo "Answer n and do a reboot if the kernel was updated."
read ANSWER
case "$ANSWER" in
  [yY]*) ;;
  *) exit ;;
esac

#------------------------------------------------------------------------------
# RPM Fusion
# See [1].

sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#------------------------------------------------------------------------------
# Multimedia
# See [2].
#
# Note: couldn't do the gstreamer plugins unless I specified arch .x86_64.
# Otherwise I get:
# Error: Transaction test error:
#   file /usr/share/doc/gstreamer1-plugins-bad-free/NEWS from install of gstreamer1-plugins-bad-free-1.22.1-1.fc38.i686 conflicts with file from package gstreamer1-plugins-bad-free-1.22.2-1.fc38.x86_64
#   file /usr/share/doc/gstreamer1-plugins-bad-free/RELEASE from install of gstreamer1-plugins-bad-free-1.22.1-1.fc38.i686 conflicts with file from package gstreamer1-plugins-bad-free-1.22.2-1.fc38.x86_64
#   file /usr/share/doc/gstreamer1-plugins-good/NEWS from install of gstreamer1-plugins-good-1.22.1-1.fc38.i686 conflicts with file from package gstreamer1-plugins-good-1.22.2-1.fc38.x86_64
#   file /usr/share/doc/gstreamer1-plugins-good/RELEASE from install of gstreamer1-plugins-good-1.22.1-1.fc38.i686 conflicts with file from package gstreamer1-plugins-good-1.22.2-1.fc38.x86_64

sudo dnf install -y --best --allowerasing --skip-broken gstreamer1-plugins-{bad-\*,good-\*,base}.x86_64 --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade -y --with-optional Multimedia
sudo dnf install -y vlc

package ffmpeg mplayer

#------------------------------------------------------------------------------
# Enable GUI application metadata in software installation GUIs.

sudo dnf -y group update core

#------------------------------------------------------------------------------
# Audio and music.

package pavucontrol soundconverter audacity
flatpak install -y flathub com.spotify.Client

#------------------------------------------------------------------------------
# NVIDIA driver.
# See [3].

sudo dnf install -y akmod-nvidia
sudo dnf install -y xorg-x11-drv-nvidia-cuda 

#------------------------------------------------------------------------------
# GUI Desktop.
# See [4].

package gnome-extensions-app gnome-tweaks 
package gnome-terminal-nautilus
package conky lm_sensors hddtemp
package curl cabextract xorg-x11-font-utils fontconfig
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
package dconf-editor

#------------------------------------------------------------------------------
# Remove and install Gnome extension system packages.

sudo dnf remove -y \
  gnome-shell-extension-window-list \
  gnome-shell-extension-places-menu

# Restore overzealously removed dependencies of those.
package gnome-shell-extension-apps-menu
package gnome-shell-extension-launch-new-instance  

package gnome-shell-extension-caffeine
package gnome-shell-extension-just-perfection
#package gnome-shell-extension-unite

#------------------------------------------------------------------------------
# Python.

sudo dnf install -y python3-pip

#------------------------------------------------------------------------------
# Minecraft and Java programming.

package java-1.8.0-openjdk-devel
package java-17-openjdk-devel
package java-latest-openjdk-devel
package maven

#------------------------------------------------------------------------------
# Clojure.

package clojure clojure-core-specs-alpha clojure-spec-alpha 
package clojure-maven-plugin

#------------------------------------------------------------------------------
# C/C++ programming.

sudo dnf -y groupinstall "Development tools"
sudo dnf -y install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms

#------------------------------------------------------------------------------
# General file utilities.

package terminator micro gedit jq meld
package meld
package unzip p7zip p7zip-plugins unrar

#------------------------------------------------------------------------------
# Image and video manipulation.

package gthumb gimp inkscape
package obs-studio

#------------------------------------------------------------------------------
# Steam.

sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam
package steam

#------------------------------------------------------------------------------
# /etc/fstab: mount external drive by label at predictable location.
# https://askubuntu.com/questions/14365/mount-an-external-drive-at-boot-time-only-if-it-is-plugged-in
# Use a 3s timeout for systemd's attempt to mount at boot.

if ! grep -q 'LABEL=external' /etc/fstab; then
  sudo bash -c "cat >> /etc/fstab <<-EOF

LABEL=external	/media/external	auto	defaults,nofail,x-systemd.device-timeout=3	0 	0
EOF"
fi

#------------------------------------------------------------------------------
# Set primary group of these users to "users".

div
set_group_to_users david
set_group_to_users dsilver
div
echo "NOTE: If the primary group ID of your user changed, you will need to log"
echo "out (or even reboot for external locations such as /data)."
