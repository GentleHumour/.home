#!/bin/bash

cd ~/.minecraft/screenshots

#------------------------------------------------------------------------------
# Move each screenshot into the directory corresponding to the date when it was
# taken.

NAMED_FILE_PATTERN='^./[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}\.[0-9]{2}\.[0-9]{2}-[a-zA-Z0-9_]*\.png$'
NAMED_DIR_PATTERN='./[0-9]*-[0-9]*-[0-9]*_[0-9]*\.[0-9]*\.[0-9]*-\([a-zA-Z0-9_]*\)\.png'

for FILE in $(find . -maxdepth 1 -regextype posix-extended -regex "$NAMED_FILE_PATTERN"); do
  DIR=$(expr match "$FILE" "$NAMED_DIR_PATTERN")
  mkdir -p "$DIR" && mv "$FILE" "$DIR"/
done

#------------------------------------------------------------------------------
# Move each remaining screenshot into the directory corresponding to the date 
# when it was taken.

DATED_FILE_PATTERN='^./[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}\.[0-9]{2}\.[0-9]{2}\.png$'
DATED_DIR_PATTERN='./\([0-9]*-[0-9]*-[0-9]*\)_.*\.png'

for FILE in $(find . -maxdepth 1 -regextype posix-extended -regex "$DATED_FILE_PATTERN"); do
  DIR=$(expr match "$FILE" "$DATED_DIR_PATTERN")
  mkdir -p "$DIR" && mv "$FILE" "$DIR"/
done


