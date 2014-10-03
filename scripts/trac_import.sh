#!/bin/bash

TRAC_ENV=/var/www/trac/envs/notes
THIS_SCRIPT=$(basename "$0")

if [ $# -eq 0 ]; then
  echo >&2 "Usage: $THIS_SCRIPT <files>"
  exit 1
fi

for file in "$@"; do
  path=$(basename "$file" | sed 's@%2F@/@g')
  printf "%s\t->\t%s\n" "$file" "$path"
  trac-admin "$TRAC_ENV" wiki import "$path" "$file"
done
