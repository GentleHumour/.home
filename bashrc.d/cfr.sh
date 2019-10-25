decompile() {(
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
    java -jar ~/bin/jars/cfr-0.146.jar --showversion false --outputdir . "$JAR"
)}
