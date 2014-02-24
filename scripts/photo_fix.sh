#!/bin/bash

dir=.
if [ $# -eq 1 ]; then
  dir="$1"
fi
cd "$dir"

# Rename *.JPG as *.jpg.
for f in `ls *.JPG 2>/dev/null`; do 
  mv "$f" "${f%\.JPG}".jpg
done

for f in `ls *.jpg 2>/dev/null`; do
  # Globbing expansion of [0-9]{4} doesn't work in case statement.  (Why?)
  # So resort to expr instead (which doesn't support [0-9]+).
  match=`expr match "$f" '[0-9][0-9]*-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]*_.*.jpg$'`
  if [ "$match" -lt 23 ]; then
    chmod -x "$f"
    jhead -autorot -nf%Y-%m-%d_%H%M%S_%f "$f"
    #echo "PROCESS $f"
  fi
done
