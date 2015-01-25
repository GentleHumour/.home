#------------------------------------------------------------------------------
# This function echoes a CLASSPATH variable in UNIX format by concatenating
# the names of JAR files and symbolic links to JAR files and directories 
# that are contained in the directory specified by the first argument, $1.
# Arguments:
#   dir = $1  The directory whose contents are used to generate the class path.

makeClassPath()
{
  dir="$1"
  if [ -d "$dir" ]; then
    ordinaryJars="$(find $dir -name "*.jar" -type f -printf %p:)"
    linkedJars="$(find $dir -name "*.jar" -type l -printf %l:)"
    linkedDirs="$(find $dir -type l -xtype d -printf %l:)"
    # Strip off the trailing ':'.
    expr "$ordinaryJars$linkedJars$linkedDirs" : '\(.*\):$'
  fi
}

#------------------------------------------------------------------------------
# Set up the CLASSPATH according to what is in the ~/lib directory.

if $CYGWIN; then
  origCP="$(cygpath --path --unix -i "$CLASSPATH")"
else
  origCP="$CLASSPATH"
fi
CLASSPATH=
if [ "$origCP" != "" ]; then
  CLASSPATH="$origCP:"
fi
CLASSPATH="$CLASSPATH$(makeClassPath ~/lib)"
if $CYGWIN; then
  CLASSPATH="$(cygpath --path --windows -i "$CLASSPATH")"
fi
export CLASSPATH

