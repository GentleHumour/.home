if type -p yarn >&/dev/null; then
  export PATH="`yarn global bin`:$PATH" >&/dev/null
fi
