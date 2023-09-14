
# With Fedora 30, the workon command has disappeared and none of the
# python2-virtualenv* packages include it. Maybe the python3 ones?

workon() {
    . ~/.virtualenvs/"$1"/bin/activate
}

alias venv='python3 -m venv .env'
