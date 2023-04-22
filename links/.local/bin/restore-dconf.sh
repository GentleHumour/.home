#!/bin/bash
#------------------------------------------------------------------------------
# Restore up the dconf database.
#
# Backup files are named after the database path, replacing '/' with ':'.
#------------------------------------------------------------------------------

BACKUPS_DIR="$HOME/.home/backups/dconf"

#------------------------------------------------------------------------------
# Restore a dconf backup to the path in $1.

restore() {
  # Ensure path has a leading and trailing /.
  local file="$1"
  local path=$(basename "$file" .txt | tr : /)
  if [ "$path" == "/" ]; then
    echo "Skipping restoration of root path, '/'."
    return
  fi

  local user=$(whoami)
  echo "Restore \"$path\"."
  dconf reset -f "$path"
  sed "s/M-Y-S-E-L-F/$user/g" < "$file" | dconf load -f "$path"
  unset path file user
}

#------------------------------------------------------------------------------
# Check we have dconf installed before zapping output files.

if ! type -p dconf >&/dev/null; then
  echo >&2 "ERROR: dconf is not installed!"
  exit 1
fi

mkdir -p "$BACKUPS_DIR"

#------------------------------------------------------------------------------
# Restore all backups in $BACKUPS_DIR.

for f in $(ls $BACKUPS_DIR); do
  restore "$BACKUPS_DIR/$f"
done
