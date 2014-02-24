#------------------------------------------------------------------------------
# Both Tomcat and Ant like to see a JAVA_HOME environment variable.  Tomcat
# absolutely requires it to be a Windows path, whereas Ant can deal with either
# UNIX or Windows path formats.  In our case, this one may have already been
# set as a system environment variable in the control panel.  If so, then just
# leave well-enough alone.
#
if [ "$JAVA_HOME" = "" ]; then
  if $CYGWIN; then 
    export JAVA_HOME="$(cygpath --windows -i "$JDKHOME")"
  else
    export JAVA_HOME="$JDKHOME"
  fi
fi

