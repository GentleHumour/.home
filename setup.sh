#!/bin/bash
#------------------------------------------------------------------------------
# Patch ~/.bashrc and install symlinks to configuration in ~ and subdirectories.
# Also run setup scripts in ~/.home/setup.d/.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Insert a line into ~/.bashrc to source the rest of the config.

SOURCE=". ~/.home/.bashrc.source"
if ! grep "$SOURCE" ~/.bashrc >&/dev/null; then
    printf >> ~/.bashrc "\n$SOURCE\n"
    echo "Updated ~/.bashrc."
fi

#------------------------------------------------------------------------------
# Set up symlinks.
#
# Anything under ~/.home/links gets linked into the corresponding subdirectory
# of ~.

ESC_RED='\e[31;1m'
ESC_RST='\e[0m'
ESC_GRN='\e[32;1m'

cd $HOME/.home/links && find . -type f | grep -v '~' | while read LINK; do
    RELATIVE=${LINK#./}
    DIR=~/$(dirname "$RELATIVE")
    if [ ! -d "$DIR" ]; then
        mkdir -p "$DIR" 2>/dev/null && echo "Created directory $DIR" \
                   || echo -e "${ESC_RED}Failed to create directory $DIR$ESC_RST"
    fi
    if [ -f "$HOME/$RELATIVE" -a ! -L "$HOME/$RELATIVE" ]; then
        echo -e "$ESC_RED\"~/$RELATIVE\" already exists as an ordinary file.$ESC_RST"
    else
        if [ ! -L "$HOME/$RELATIVE" ]; then
            echo -n "NEW      "
        else
            echo -n "UPDATED  "
        fi
        if ln -fs ~/".home/links/$RELATIVE" ~/"$RELATIVE" >&/dev/null; then
            echo -e "$ESC_GRN~/$RELATIVE  $ESC_RST--->  $ESC_GRN~/.home/links/$RELATIVE$ESC_RST"
        else
            echo -e "${ESC_RED}Failed to update link ~/$RELATIVE$ESC_RST"
        fi
    fi
done

#------------------------------------------------------------------------------
# Run setup scripts.

if pushd "$HOME"/.home/setup.d >& /dev/null; then
  for f in `ls *.sh 2>/dev/null`; do 
    . $f
  done
  popd >& /dev/null
fi

