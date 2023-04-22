#!/bin/bash
#------------------------------------------------------------------------------
# Copy Eclipse preferences from one project workspace to another.
# If the destination file already exists, make a backup named after the current
# data/time.
#
# Alternative approaches might be to symlink the files from a central location
# or use the import/export feature in the menus.
# http://stackoverflow.com/questions/2078476/how-to-share-eclipse-configuration-over-different-workspaces
# http://mcuoneclipse.com/2012/04/04/copy-my-workspace-settings/
#------------------------------------------------------------------------------
# Preference files.

FILES="org.eclipse.ui.editors.prefs org.eclipse.jdt.ui.prefs org.eclipse.cdt.ui.prefs"

#------------------------------------------------------------------------------
# Constants.

SETTINGS_REL=".metadata/.plugins/org.eclipse.core.runtime/.settings"
TIME=$(date '+%Y-%m-%d_%H%M%S')

#------------------------------------------------------------------------------
# Verify command line arguments.

if [ $# -ne 2 ]; then
    echo >&2 "Usage: $(basename "$0") <source-workspace-dir> <destination-workspace-dir>"
    echo >&2 "       Copy Eclipse preferences from one project workspace to another."
    exit 1
fi

SRC_WS="$1"
DEST_WS="$2"

if [ ! -d "$SRC_WS" ]; then
    echo >&2 "Source workspace directory does not exist."
    exit 1
fi
if [ ! -d "$DEST_WS" ]; then
    echo >&2 "Destination workspace directory does not exist."
    exit 1
fi
if [ "$SRC_WS" == "$DEST_WS" ]; then
    echo >&2 "Source and destination workspaces cannot be the same."
    exit 1
fi

#------------------------------------------------------------------------------
# Compute full settings directory paths.

SRC_DIR="$SRC_WS/$SETTINGS_REL"
DEST_DIR="$DEST_WS/$SETTINGS_REL"

#------------------------------------------------------------------------------
# Create destination directory.

mkdir -p "$DEST_DIR" >&/dev/null

#------------------------------------------------------------------------------
# Copy each prefs file that exists at the source. 


for REL in $FILES; do
    SRC="$SRC_DIR/$REL"
    DEST="$DEST_DIR/$REL"

    if [ -f "$SRC" ]; then
        if [ -f "$DEST" ]; then
            # Back up destination files prior to overwriting.
            BACKUP="$DEST.$TIME"
            mv "$DEST" "$BACKUP"
            echo "$REL backed up to $BACKUP"
        fi
        
        cp "$SRC" "$DEST"
        echo "$REL copied to $DEST_DIR"
    else
        echo "$REL does not exist in $SRC_DIR"
    fi
done

