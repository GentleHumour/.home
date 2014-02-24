#------------------------------------------------------------------------------
# $1 = shade from 0 (black) to 23 (white)
#   Generate the escape sequence for the specified greyscale foreground colour.

fg_grey()
{
  echo -en '\e[38;5;'$((232+$1))m
}

#------------------------------------------------------------------------------
# $1 = shade from 0 (black) to 23 (white)
#   Generate the escape sequence for the specified greyscale background colour.

bg_grey()
{
  echo -en '\e[48;5;'$((232+$1))m
}

#------------------------------------------------------------------------------
# $1 = red   (0 - 5)
# $2 = green (0 - 5)
# $3 = blue  (0 - 5)
#   Generate the escape sequence for the specified RGB foreground colour.

fg_rgb()
{
  echo -en '\e[38;5;'$((16 + 36*$1 + 6*$2 + $3))m
}

#------------------------------------------------------------------------------
# $1 = red   (0 - 5)
# $2 = green (0 - 5)
# $3 = blue  (0 - 5)
#   Generate the escape sequence for the specified RGB foreground colour.

bg_rgb()
{
  echo -en '\e[48;5;'$((16 + 36*$1 + 6*$2 + $3))m
}

#------------------------------------------------------------------------------

prompt_command()
{
  local RESULT=$?
  
  #----------------------------------------------------------------------------
  # Powerline font right- and left pointing triangle symbol. 
  # https://github.com/Lokaltog/powerline-fonts/
  # https://powerline.readthedocs.org/en/latest/fontpatching.html
  #
  # Right: U+e0b0 (Ctrl-Shift-u e0b0).
  # Left:  U+e0b2 (Ctrl-Shift-u e0b2).

  local RTRI=
  local LTRI=

  #----------------------------------------------------------------------------
  # Standard elipsis character.

  local ELIPSIS=…

  #----------------------------------------------------------------------------
  # Useful escape sequences. 
  # http://en.wikipedia.org/wiki/ANSI_escape_code
  # http://www.termsys.demon.co.uk/vtansi.htm
  #
  # ESC_CLREOL     Clear to end of line.
  # ESC_NL         Cursor to start of next line.

  local ESC_CLREOL='\e[K'
  local ESC_BOLD='\e[1m'
  local ESC_RESET='\e[0m'

  # Linux console does not support a title bar or 256 colour mode.
  if [ "$TERM" == "linux" ]; then
    if [ "$RESULT" == 0 ]; then
      local COL_USER='\e[44;37;1m'
    else
      local COL_USER='\e[41;37;1m'
    fi
    local COL_TIME='\e[42;37;1m'
    local COL_PATH='\e[43;37;1m'
    export PS1="${COL_USER}  \u @ \h  ${COL_TIME}  \t  ${COL_PATH}  \w${ESC_CLREOL}${ESC_RESET}\n> "
  else
    local BG_BLK=$(bg_rgb 0 0 0)
    local FG_BLK=$(fg_rgb 0 0 0)
    local BG_WHT=$(bg_rgb 5 5 5)
    local FG_WHT=$(fg_rgb 5 5 5)
    local BG_LBL=$(bg_rgb 0 1 5)
    local FG_LBL=$(fg_rgb 0 1 5)
    local BG_DCY=$(bg_rgb 0 1 1)
    local FG_DCY=$(fg_rgb 0 1 1)
    local BG_PUR=$(bg_rgb 1 0 3)
    local FG_PUR=$(fg_rgb 1 0 3)
    local BG_RED=$(bg_rgb 3 0 0)
    local FG_RED=$(fg_rgb 3 0 0)
    if [ "$RESULT" == 0 ]; then
      local FG="$FG_LBL"
      local BG="$BG_LBL"
    else
      local FG="$FG_RED"
      local BG="$BG_RED"
    fi
    export PS1="\e]2;\u@\h \t \w\a${BG}${ESC_BOLD}${FG_WHT}  \u @ \h  ${FG}${BG_DCY}${RTRI}${FG_WHT}  \t  ${FG_DCY}${BG_PUR}${RTRI}${FG_WHT}  \w${ESC_CLREOL}${ESC_RESET}\n${RTRI} "
  fi
}

PROMPT_COMMAND=prompt_command
export PS2="$ELIPSIS"

