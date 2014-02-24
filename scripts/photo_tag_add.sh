#!/bin/bash
#------------------------------------------------------------------------------
# If DEBUG is true, enable debugging and don't perform any actions.

DEBUG=false

#------------------------------------------------------------------------------

THIS_SCRIPT=$(basename "$0")
DATE_TIME_REGEXP='[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9]_'
DATE_TIME_EXPR="^\($DATE_TIME_REGEXP\).*"
TAG_EXPR="^$DATE_TIME_REGEXP\(.*\)\.jpg"

#------------------------------------------------------------------------------
# If $DEBUG is true, echo all arguments; otherwise do nothing.

fn_debug()
{
  if $DEBUG; then
    echo "$@"
  fi
}


#------------------------------------------------------------------------------
# Show error message to stderr and exit with error code specified by $1.

fn_error()
{
  CODE="$1"
  shift
  echo >&2 "ERROR: $@"
  exit "$CODE"
}

#------------------------------------------------------------------------------
# Show usage and exit with error status.

fn_usage()
{
  echo "Usage: $THIS_SCRIPT <tags> <file1> .... <fileN>"
  echo 
  echo "Multiple tags can be added by surrounding them with double quotes, e.g."
  echo "  $THIS_SCRIPT \"japan me\" *.jpg"
  echo
  exit 1
}

#------------------------------------------------------------------------------
# Return the date/time component of the image file name specified in $1, 
# comprising the date and time of the photo in the form ####-##-##_######_.

fn_date_time()
{(
  expr match "$1" "$DATE_TIME_EXPR"
)}

#------------------------------------------------------------------------------
# List the tags specified in the file name in $1, one per line.
# Tags in the following forms are removed:
#   dsc#####
#   Image###
#   Image####
#   img_####

fn_tags()
{(
  expr match "$1" "$TAG_EXPR" | tr '_' '\n' | egrep -iv 'dsc[0-9]{5}|image[0-9]{3,4}|img_[0-9]{4}'
)}

#------------------------------------------------------------------------------
# Given the tags in $*, ensure that each tag appears only once, without changing
# the order of the first occurrence of each tag.

fn_unique_tags()
{(
  declare -a UNIQUE_TAGS=()
  for TAG; do
    IS_UNIQUE=true
    for U in ${UNIQUE_TAGS[*]}; do
      if [ "$U" == "$TAG" ]; then
        IS_UNIQUE=false
        break
      fi
    done
    if $IS_UNIQUE; then
      UNIQUE_TAGS=(${UNIQUE_TAGS[*]} $TAG)
    fi
  done
  echo ${UNIQUE_TAGS[*]}
)}

#------------------------------------------------------------------------------
# Add the tag specified in $1 to the file named in $2, and rename the file 
# accordingly.

fn_rename_file()
{(
  declare -a TAGS=($1)
  FILE="$2"
  fn_debug TAGS = "${TAGS[*]}"
  fn_debug \#TAGS = "${#TAGS[*]}"
  fn_debug FILE = "$FILE"
  DATE_TIME=$(fn_date_time "$FILE")
  
  declare -a OLD_TAGS=($(fn_tags "$FILE"))
  fn_debug OLD_TAGS = "${OLD_TAGS[*]}"
  
  declare -a NEW_TAGS=($(fn_unique_tags ${OLD_TAGS[*]} ${TAGS[*]}))
  NEW_FILE_BASE="$DATE_TIME"$(echo "${NEW_TAGS[*]}" | tr ' ' '_')  
  NEW_FILE="$NEW_FILE_BASE.jpg"
  fn_debug NEW_FILE = "$NEW_FILE"
  if [ -e "$NEW_FILE" ]; then
    # If you take more than one photo per second, the DATE_TIME prefix will not
    # be unique.  Add a numeric suffix to the filename until it is unique.
    NEW_FILE_NUM=2
    while true; do
      NEW_FILE="${NEW_FILE_BASE}_${NEW_FILE_NUM}.jpg"
      if [ ! -e "$NEW_FILE" ]; then
        break
      fi
      NEW_FILE_NUM=$((NEW_FILE_NUM + 1))
    done
  fi
  if $DEBUG; then
    fn_debug mv "$FILE" "$NEW_FILE"
  else
    mv "$FILE" "$NEW_FILE"
  fi
)}

#------------------------------------------------------------------------------
# Check command line arguments, and then shift tags to add into $TAGS, 
# converting any whitespace in the tag to underscores.  Use a single underscore 
# to represent multiple consecutive whitespace characters.

if [ $# -lt 2 ]; then
  fn_usage
fi

TAGS=$(echo $1 | tr --squeeze-repeats '[\a\b\f\n\r\t\v ]' ' ')
shift
TAGS=$(fn_unique_tags $TAGS)

#------------------------------------------------------------------------------
# Check that all command line arguments are JPEG images.

for FILE; do
  if [ ! -e "$FILE" ]; then
    fn_error 1 "\"$FILE\" does not exist."
  elif [ $(file -ib "$FILE" | cut -d\; -f1) != "image/jpeg" ]; then
    fn_error 1 "\"$FILE\" is not a JPEG image."
  fi
done

#------------------------------------------------------------------------------
# If we haven't quit due to errors prior to this point, process all the files.

for FILE; do
  fn_rename_file "$TAGS" "$FILE"
done


