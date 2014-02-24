#------------------------------------------------------------------------------
# Cygwin support.  $CYGWIN must be set to either true or false.

case "$(uname)" in
  CYGWIN*)
    CYGWIN=true
    ;;
  *)
    CYGWIN=false 
    ;;
esac

#------------------------------------------------------------------------------
# Set up the APPROOT variable to refer to wherever all the development apps
# are stored.

if $CYGWIN; then
  export EDITOR=np
  export APPROOT=/mnt/c/apps
else
  export EDITOR=gedit
  export APPROOT=/opt
fi

