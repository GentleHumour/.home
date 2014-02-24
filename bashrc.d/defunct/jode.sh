JODE_VERSION=1.1.2-pre1
export JODE_HOME=/opt/jode-$JODE_VERSION
export CLASSPATH="$CLASSPATH:$JODE_HOME/lib/jode-$JODE_VERSION.jar"
alias jodegui="java jode.swingui.Main &"
alias jode="java jode.decompiler.Main"
