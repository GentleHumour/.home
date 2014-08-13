#export JDK_HOME=/opt/jdk1.6.0_21
#export JDK_HOME=/opt/jdk1.6.0_45
export JDK_HOME=/opt/jdk1.7.0_25
export PATH=$JDK_HOME/bin:$PATH

#------------------------------------------------------------------------------
# Convert Cp1252 (Windows) encoding to UTF-8.
#
# An alternative way with Maven is to tell it to expect the Windows encoding:
#   export JAVA_TOOL_OPTIONS='-Dfile.encoding=Cp1252'

win-to-utf8()
{
  if [ $# -eq 0 ]; then
    echo >&2 "ERROR: usage $0 <file>"
    false
    return
  fi
  
  for f in "$@"; do
    if [ -r "$f".Cp1252 ]; then
      echo "$f.Cp1252 exists; probably already converted. Skipping."
    else
      if [ -r "$f" ]; then
        iconv -f WINDOWS-1252 -t UTF-8 < "$f" > "$f".utf8 && \
          mv "$f" "$f".Cp1252 && mv "$f".utf8 "$f" && \
          echo "Converted $f to UTF-8." || \
          echo "$f could not be converted."
      else
        echo "Can't open $f to read."
      fi
    fi
  done
}
