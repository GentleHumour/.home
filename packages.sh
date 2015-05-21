#!/bin/bash

#sudo yum -y update

PACKAGES=

# Fedora release version.
FEDORA_RELEASE=20

# Package repositories and management.
sudo yum -y localinstall --nogpgcheck \
    http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_RELEASE.noarch.rpm \
    http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_RELEASE.noarch.rpm

sudo rpm -ivh http://rpm.livna.org/livna-release.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-livna

# For flash-plugin:
sudo rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

PACKAGES="$PACKAGES yumex yum-plugin-fastestmirror"

sudo yum -y install $PACKAGES
PACKAGES=

# Programming.
sudo yum -y groupinstall "Development Tools" "Development Libraries"
PACKAGES="$PACKAGES git subversion nano emacs"

# Building kernels.
PACKAGES="$PACKAGES binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms"

# Compression.
PACKAGES="$PACKAGES cabextract p7zip p7zip-plugins unrar xz-lzma-compat"

# Printing.
PACKAGES="$PACKAGES cups-pdf"

# Interwebs.
PACKAGES="$PACKAGES wget flash-plugin icedtea-web"

# Gnome.
PACKAGES="$PACKAGES gnome-tweak-tool dconf-editor"

# Nautilus, including brasero-nautilus for burning ISOs.
PACKAGES="$PACKAGES nautilus-actions nautilus-image-converter nautilus-open-terminal nautilus-pastebin brasero-nautilus"

# Gstreamer.
PACKAGES="$PACKAGES gstreamer gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-plugins-bad-nonfree"

# FFMpeg.
PACKAGES="$PACKAGES ffmpeg ffmpeg-libs gstreamer-ffmpeg"

# Moldy media.
PACKAGES="$PACKAGES libdvdcss vlc mplayer mplayer-gui smplayer gnome-mplayer"

# Audio editing.
PACKAGES="$PACKAGES audacity-freeworld"

# Video editing.
PACKAGES="$PACKAGES avidemux"

# Gimp.
PACKAGES="$PACKAGES gimp gimp-data-extras gimpfx-foundry gimp-lqr-plugin gimp-resynthesizer gnome-xcf-thumbnailer"

# Diagrams.
PACKAGES="$PACKAGES inkscape dia"

# LibreOffice.
PACKAGES="$PACKAGES hunspell hunspell-en hunspell-en-GB"

# Octave.
PACKAGES="$PACKAGES octave octave-audio octave-doc octave-general octave-image octave-quaternion octave-signal plplot-octave"

# LaTeX.
PACKAGES="$PACKAGES kile"

sudo yum -y install $PACKAGES

