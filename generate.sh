#!/bin/bash

set -e

DART_SASS_VERSION="1.101.0"

COMPILER="./dart-sass/sass"

# Check if ImageMagick is installed
if [ ! "$(which magick)" ]; then
	echo "You don't have ImageMagick installed."
	echo "Aborting..."
	exit 1
fi

# Check that we're in the directory the script is in
if [ ! -f "${PWD}/$(basename $0)" ]; then
	echo "You can't run this script here!"
	echo "Aborting..."
	exit 1
fi

# Download and unpack the dart-sass compiler if it doesn't exist or if the version doesn't match
if [ "$($COMPILER --version 2> /dev/null)" != "$DART_SASS_VERSION" ]; then
	echo "Downloading dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz..."
	[ -d "./dart-sass" ] && echo "Removing old Sass directory..." && rm -r "./dart-sass"
	mkdir -p "./dart-sass"
	wget -q -P "./dart-sass" "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
	echo "Unpacking dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz..."
	tar xf "./dart-sass/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
	rm "./dart-sass/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
fi

# Copy relevant theme files
[ -d "./SlickCold" ] && echo "Removing old SlickCold directory..." && rm -r "./SlickCold"
[ -d "./SlickFire" ] && echo "Removing old SlickFire directory..." && rm -r "./SlickFire"
echo "Copying files..."
cp -r "./src" "./SlickCold"
cp -r "./src" "./SlickFire"

# Transform SlickCold to SlickFire
echo "Transforming SlickCold..."
find "./SlickFire" -regex ".*\.png\|.*\.jpg" -type f -print0 | xargs -0 -I{} magick {} -channel-fx "blue, red, red" "{}.out"
find "./SlickFire" -regex ".*\.png\|.*\.jpg" -type f -print0 | xargs -0 -I{} mv "{}.out" "{}"
sed -i "s/#\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)/#\3\1\1/g" "./SlickFire/gtk-3.0/internal/_gradients.scss"
sed -i "s/#\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)/#\3\1\1/g" "./SlickFire/gtk-2.0/gtkrc"
sed -i "s/SlickCold/SlickFire/g" "./SlickFire/metacity-1/metacity-theme-1.xml" "./SlickFire/metacity-1/metacity-theme-3.xml"
sed -i "s/DarkCold/DarkFire/g;s/OriginalSeed/infinity0/g" "./SlickFire/metacity-1/metacity-theme-1.xml" "./SlickFire/metacity-1/metacity-theme-3.xml"

# Compile Sass to CSS
echo "Compiling Sass..."
$COMPILER --no-source-map "./SlickCold/gtk-3.0/gtk.scss" "./SlickCold/gtk-3.0/gtk.css"
$COMPILER --no-source-map "./SlickCold/gtk-3.0/chrome.scss" "./SlickCold/chrome.css"
$COMPILER --no-source-map "./SlickFire/gtk-3.0/gtk.scss" "./SlickFire/gtk-3.0/gtk.css"
$COMPILER --no-source-map "./SlickFire/gtk-3.0/chrome.scss" "./SlickFire/chrome.css"

# Clean up unneeded files
echo "Cleaning up..."
rm -r "./SlickCold/gtk-3.0/internal"
rm -r "./SlickCold/gtk-3.0/widgets"
rm -r "./SlickCold/gtk-3.0/apps"
find "./SlickCold" -name "*.scss" -print0 | xargs -0 rm
rm -r "./SlickFire/gtk-3.0/internal"
rm -r "./SlickFire/gtk-3.0/widgets"
rm -r "./SlickFire/gtk-3.0/apps"
find "./SlickFire" -name "*.scss" -print0 | xargs -0 rm

echo "Done."
