#!/bin/bash

set -e

COMPILER="./compiler/dart-sass/sass"

# Check if ImageMagick is installed
if [ ! "$(which magick)" ]; then
	echo "You don't have ImageMagick installed."
	echo "Aborting..."
	exit 1
fi

# Check that we're in the directory the script is in
if [ ! -f "${PWD}/$(basename $0)" ]; then
	echo "You can't run this script here!"
	exit 1
fi

# Copy relevant theme files
if [ -d ./SlickCold ] && [ -d ./SlickFire ]; then
	echo "Removing './SlickCold' and './SlickFire'..."
	rm -r "./SlickCold" "./SlickFire";
fi
if [ ! -d ./SlickCold ] && [ ! -d ./SlickFire ]; then
	echo "Copying files..."
	cp -r "./src" "./SlickCold"
	cp -r "./src" "./SlickFire"
else
	echo "Stale directories detected, you must do manual cleanup."
	echo "Aborting..."
	exit 1
fi

# Transform SlickCold to SlickFire
echo "Transforming SlickCold..."
find "./SlickFire" -regex ".*\.png\|.*\.jpg" -type f -print0 | xargs -0 -I{} magick {} -channel-fx "blue, red, red" "{}.out"
find "./SlickFire" -regex ".*\.png\|.*\.jpg" -type f -print0 | xargs -0 -I{} mv "{}.out" "{}"
sed -i "s/#\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)/#\3\1\1/g" "./SlickFire/gtk-3.0/internal/_gradients.scss"
sed -i "s/#\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)\([0-9A-Fa-f]\{2\}\)/#\3\1\1/g" "./SlickFire/gtk-2.0/gtkrc"
sed -i "s/SlickCold/SlickFire/g" "./SlickFire/index.theme" "./SlickFire/metacity-1/metacity-theme-1.xml" "./SlickFire/metacity-1/metacity-theme-3.xml"
sed -i "s/DarkCold/DarkFire/g;s/OriginalSeed/infinity0/g" "./SlickFire/metacity-1/metacity-theme-1.xml" "./SlickFire/metacity-1/metacity-theme-3.xml"

# Compile Sass to CSS
echo "Compiling Sass..."
"$COMPILER" --no-source-map "./SlickCold/gtk-3.0/gtk.scss" "./SlickCold/gtk-3.0/gtk.css"
"$COMPILER" --no-source-map "./SlickCold/gtk-3.0/chrome.scss" "./SlickCold/chrome.css"
"$COMPILER" --no-source-map "./SlickFire/gtk-3.0/gtk.scss" "./SlickFire/gtk-3.0/gtk.css"
"$COMPILER" --no-source-map "./SlickFire/gtk-3.0/chrome.scss" "./SlickFire/chrome.css"

# Clean up unneeded files
echo "Cleaning up..."
rm -r "./SlickCold/gtk-3.0/internal"
rm -r "./SlickCold/gtk-3.0/widgets"
rm -r "./SlickCold/gtk-3.0/apps"
find "./SlickCold" -name "*.scss" | xargs rm
rm -r "./SlickFire/gtk-3.0/internal"
rm -r "./SlickFire/gtk-3.0/widgets"
rm -r "./SlickFire/gtk-3.0/apps"
find "./SlickFire" -name "*.scss" | xargs rm

echo "Done."
