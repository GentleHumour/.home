#------------------------------------------------------------------------------
# Convert all text files in $* to UNIX format, by erasing the carriage return
# (CR) characters.

nocr()
{
  if [ $# -eq 0 ]; then
    echo >&2 "Specify a list of files to convert to UNIX text format."
  else
    for f in $*; do
      mv $f $f.old
      tr -d '\r' < $f.old > $f
      rm -f $f.old
    done
  fi
}

#------------------------------------------------------------------------------
# xterm, coloured.
# SSH into "$1", which is of the form "host" or "user@host".
# Set background colour to optional parameter $2.
# Set foreground colour to optional parameter $3.

xtc()
{
  BG="${2:-black}"
  FG="${3:-white}"
  ssh -X -f "$1" "xterm -bg '$BG' -fg '$FG'"
}

#------------------------------------------------------------------------------
# Implementation of search and isearch.
# Arguments:
#   $1 - caller, "search" or "isearch" (case insensitive)
#   Remainder: [path][glob] regexp

__search()
{
  if [ "$1" = "isearch" ]; then  
    CASE_ARG="-i"
  fi
  
  if [ $# -eq 2 ]; then
    # search 'text'
    DIR=.
    GLOB='*'
    PATTERN=$2
  elif [ $# -eq 3 ]; then
    # search 'path/to/*.java' text
    DIR=$(dirname "$2")
    GLOB=$(basename "$2")
    PATTERN="$3"
  else
    echo "Usage: $0 \'[path/to/][glob]\' \'regexp\'"
    false
    return
  fi

  find "$DIR" -iname "$GLOB" -exec egrep $CASE_ARG "$PATTERN" {} /dev/null \;
}

#------------------------------------------------------------------------------
# Search files for matching text.
# search  [path/to/][glob] regexp
# isearch [path/to/][glob] regexp  (case-insensitive variant)

search() 
{ 
  __search ${FUNCNAME[0]} "$@" 
}
isearch() 
{
  __search ${FUNCNAME[0]} "$@"
}


#------------------------------------------------------------------------------

