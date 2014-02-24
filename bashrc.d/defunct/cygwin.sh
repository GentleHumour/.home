
TERM=xterm
SR=`cygpath -u -i "$SYSTEMROOT"`
PATH=$PATH:$SR/system32:$SR/system32/wbem
export PATH
unset SR

#------------------------------------------------------------------------------
# This function takes a UNIX style path to a file, and, if on the Win32 
# platform, converts it into a Win32-specific file path.

localFile()
{
  if $CYGWIN; then
    cygpath -w -i "$*"
  else
    echo "$*"
  fi
}

#------------------------------------------------------------------------------
# Run notepad on a text file.  Useful under Windows. ;-)

np()
{
  for f in "$@"; do 
    fileName=`cygpath -w -i "$f"`
    notepad "$fileName" &
  done
}

#------------------------------------------------------------------------------
# Run wordpad on a text file.  Useful under Windows. ;-)

wp()
{
  for f in "$@"; do 
    fileName=`cygpath -w -i "$f"`
    '/mnt/C/Program Files/Windows NT/Accessories/wordpad.exe' "$fileName" &
  done
}

