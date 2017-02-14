#------------------------------------------------------------------------------

alias ls='ls --color=auto -F'
alias la='ls --color=auto -la'
alias dump='od -t x1'

#------------------------------------------------------------------------------
# Set up PATH

export PATH=$PATH:~/.home/scripts:~/bin

#------------------------------------------------------------------------------

export HISTIGNORE="&:ls:[bf]g:history:exit"
HISTTIMEFORMAT=$(echo -en '%F  %T\t')
HISTFILESIZE=100000
HISTSIZE=100000
PROMPT_COMMAND='history -a'

# Make history append to the history file immediately to support multiple
# open terminals.
shopt -s histappend
shopt -s cdspell
shopt -s cmdhist

