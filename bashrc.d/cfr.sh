decompile() {(
    CP="$HOME/minecraft/Spigot/1.15/api/spigot-api-1.15-R0.1-SNAPSHOT-shaded.jar"

    if [ $# -ne 1 ]; then
        echo >&2 "Usage: decompile <jarfile>"
        exit 1
    fi
    JAR="$1"
    if [ ! -f "$JAR" ]; then
        echo >&2 "ERROR: can't open $JAR"
        exit 1
    fi

    jar xf "$JAR"
    java -jar ~/bin/jars/cfr-0.149.jar --showversion false --renamedupmembers true --outputdir . "$JAR"
)}
