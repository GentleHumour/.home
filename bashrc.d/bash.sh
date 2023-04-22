#------------------------------------------------------------------------------

alias ls='ls --color=auto -F'
alias la='ls --color=auto -la'
alias dump='od -t x1'

#------------------------------------------------------------------------------
# Set up PATH

export PATH=$PATH:~/.home/scripts:~/bin

#------------------------------------------------------------------------------
# Gets more config files out of the home directory. Note however that if unset
# then this is the default. It is set for the benefit of non-compliant apps.

export XDG_CONFIG_HOME=~/.config

#------------------------------------------------------------------------------

export HISTIGNORE="&:ls:[bf]g:history:exit"
HISTTIMEFORMAT=$(echo -en '%Y-%m-%d  %T\t')
HISTFILESIZE=100000
HISTSIZE=100000
PROMPT_COMMAND='history -a'

# Make history append to the history file immediately to support multiple
# open terminals.
shopt -s histappend
shopt -s cdspell
shopt -s cmdhist
