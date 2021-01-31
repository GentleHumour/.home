#!/bin/bash

BUILD_DIR=~/minecraft/buildtools
SPIGOT_DIR=~/minecraft/Spigot

#------------------------------------------------------------------------------

error() {
    echo >&2 "$@"
}

#------------------------------------------------------------------------------

die() {
    error "$@"
    exit 1
}

#------------------------------------------------------------------------------

if [ $# -ne 1 ]; then
    die "Usage: $(basename $0) <rev>"
fi
REV="$1"
echo "Revision: $REV"

#------------------------------------------------------------------------------

REV_DIR="$SPIGOT_DIR/$REV"
API_DIR="$REV_DIR/api"
SRC_DIR="$API_DIR/src"
DOCS_DIR="$API_DIR/docs"

#------------------------------------------------------------------------------
# For testing:
# ECHO=echo

cd "$BUILD_DIR"
$ECHO wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar || die "Failed to update BuildTools."
$ECHO java -jar BuildTools.jar --rev "$REV" || die "Build failed."

#------------------------------------------------------------------------------
# Copy server JAR renamed with build number.

BUILD_NUMBER=$(head BuildTools.log.txt | grep name | cut -d '"' -f4)
if [ "$BUILD_NUMBER" == "" ]; then 
    die "Something went wrong. The build number is empty."
fi

$ECHO mkdir -p "$REV_DIR" || die "Failed to create server rev $REV directory."
$ECHO cp "$BUILD_DIR/spigot-$REV.jar" "$REV_DIR/spigot-$REV-b$BUILD_NUMBER.jar" || die "Failed to copy server JAR."

#------------------------------------------------------------------------------
# Copy shaded API JAR.

$ECHO cd "$BUILD_DIR/Spigot/Spigot-API" || die "API build directory does not exist."
$ECHO mkdir -p "$API_DIR" || die "Failed to create API directory."
$ECHO cp "target/spigot-api-$REV-R0.1-SNAPSHOT-shaded.jar" "$API_DIR" || die "Failed to copy API JAR."

#------------------------------------------------------------------------------
# Copy API sources.

$ECHO rm -rf "SRC_DIR" || die "Failed to clean up API source directory."
$ECHO mkdir -p "$SRC_DIR" || die "Failed to create $REV API source directory."
$ECHO rsync -a "$BUILD_DIR/Spigot/Spigot-API/src/main/java/" "$SRC_DIR" || die "Failed to copy sources."

#------------------------------------------------------------------------------
# Build and copy API JavaDocs.

$ECHO rm -rf "$DOCS_DIR" || die "Failed to clean up API docs directory."
$ECHO mkdir -p "$DOCS_DIR" || die "Failed to create $REV API docs directory."
$ECHO mvn javadoc:javadoc && $ECHO rsync -a target/site/apidocs/ "$DOCS_DIR" || die "Failed to copy JavaDocs."

