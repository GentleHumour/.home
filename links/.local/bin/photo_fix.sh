#!/bin/bash

DEBUG=
#DEBUG=echo 

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
    # Special case for WhatsApp. No EXIF tags. Just use the filename.
    # Single/double quotes around the regexp prevent a match for unknown reasons.
    if [[ "$f" =~ ^IMG-([0-9]{4})([0-9]{2})([0-9]{2})-WA([0-9]{4}).jpg$ ]]; then
      #echo ${BASH_REMATCH[*]}
      NEW="${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-${BASH_REMATCH[3]}_00${BASH_REMATCH[4]}.jpg"
      echo "$f --> $NEW"
      $DEBUG mv "$f" "$NEW"
    # Phone camera:
    elif [[ "$f" =~ ^IMG_([0-9]{8})_([0-9]{6})([0-9]{3})(_.*)?.jpg$ ]]; then
      $DEBUG jhead -autorot -nf%Y-%m-%d_%H%M%S_${BASH_REMATCH[3]}${BASH_REMATCH[4]} "$f"
    else
      $DEBUG jhead -autorot -nf%Y-%m-%d_%H%M%S_%f "$f"
    fi
    #echo "PROCESS $f"
  fi
done
