if type -p yarn >&/dev/null; then
  export PATH="$PATH:`yarn global bin`" >&/dev/null
fi