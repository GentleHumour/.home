decompile() {(
    SPIGOT_VERSION=1.16.4
    CP="$HOME/minecraft/Spigot/${SPIGOT_VERSION}/api/spigot-api-${SPIGOT_VERSION}-R0.1-SNAPSHOT-shaded.jar"

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
    java -jar ~/bin/jars/cfr-0.150.jar --showversion false --renamedupmembers true --outputdir . "$JAR"
)}
