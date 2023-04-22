#!/bin/bash
#------------------------------------------------------------------------------
# Back up the dconf database.
#
# Backup files are named after the database path, replacing '/' with ':'.
#------------------------------------------------------------------------------

BACKUPS_DIR="$HOME/.home/backups/dconf"

#------------------------------------------------------------------------------
# Back up the dconf path in $1.

backup() {
  # Ensure path has a leading and trailing /.
  local path="${1%/}/"
  path="/${path#/}"
  local file="$BACKUPS_DIR/"$(tr / : <<<"$path").txt
  local user=$(whoami)
  echo "Back up \"$path\"."
  dconf dump "$path" | sed "s/$user/M-Y-S-E-L-F/g" > "$file"
  unset path file user
}

#------------------------------------------------------------------------------
# Check we have dconf installed before zapping output files.

if ! type -p dconf >&/dev/null; then
  echo >&2 "ERROR: dconf is not installed!"
  exit 1
fi

#------------------------------------------------------------------------------
# Back up everything first, just in case, even though we won't restore it.

mkdir -p /data/backups/dconf
dconf dump / | sed "s/$(whoami)/M-Y-S-E-L-F/g" > /data/backups/dconf/$(whoami).txt

#------------------------------------------------------------------------------
# Backup settings for selected components.

mkdir -p "$BACKUPS_DIR"

backup /org/fedorahosted/background-logo-extension
backup /org/gnome/GWeather
backup /org/gnome/GWeather4
backup /org/gnome/calculator
backup /org/gnome/desktop/calendar
backup /org/gnome/desktop/interface
backup /org/gnome/desktop/peripherals
backup /org/gnome/desktop/session
backup /org/gnome/desktop/sound
backup /org/gnome/desktop/wm
backup /org/gnome/eog
backup /org/gnome/evince/default
backup /org/gnome/gedit/plugins
backup /org/gnome/gedit/preferences/editor
backup /org/gnome/gedit/preferences/print
backup /org/gnome/gedit/preferences/ui
backup /org/gnome/gnome-screenshot
backup /org/gnome/gthumb
backup /org/gnome/meld
backup /org/gnome/nautilus
backup /org/gnome/settings-daemon
backup /org/gnome/shell
backup /org/gnome/software
backup /org/gnome/system/location
backup /org/gnome/tweaks
backup /org/gtk/gtk4
backup /org/gtk/settings
backup /org/nemo
