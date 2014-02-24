#------------------------------------------------------------------------------
# Set up to run Jikes.  Jikes can use the JIKESPATH environment variable 
# instead of $CLASSPATH.  Jikes needs to be able to locate the Core Java 
# classes in rt.jar, which is in the jre/lib/ directory.  From JDK1.4.0 onwards
# the Java Cryptography Extension (JCE) is also in that directory, so we use
# makeClassPath to add all JARs there to the JIKESPATH.  Because makeClassPath
# is recursive, it adds all the stuff in jre/lib/ext/ too.

export PATH=$PATH:$APPROOT/jikes-1.14/bin
JIKESPATH=$JIKESPATH:$(makeClassPath $JDKHOME/jre/lib)
if $CYGWIN; then
  JIKESPATH=$JIKESPATH:"$(cygpath --path --unix -i "$CLASSPATH")"
else
  JIKESPATH=$JIKESPATH:$CLASSPATH
fi
if $CYGWIN; then
  JIKESPATH="$(cygpath --path --windows -i "$JIKESPATH")"
fi
export JIKESPATH
