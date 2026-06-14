#!/bin/sh

set -e

if [ -x /bin/sudo ]; then
	SUID_PROG=sudo
elif [ -x /bin/doas ]; then
	SUID_PROG=doas
elif [ -x /bin/pkexec ]; then
	SUID_PROG=pkexec
else
	echo "No SUID program detected, aborting..."
	exit 1
fi

./dart-sass/sass --no-source-map 'src/gtk-3.0/gtk.scss' 'src/gtk-3.0/gtk.css'
./generate.sh

if [ -d '/usr/share/themes/SlickCold' ]; then
	echo "Removing old SlickCold from /usr/share/themes..."
	$SUID_PROG rm -rf '/usr/share/themes/SlickCold'
fi
if [ -d '/usr/share/themes/SlickFire' ]; then
	echo "Removing old SlickFire from /usr/share/themes..."
	$SUID_PROG rm -rf '/usr/share/themes/SlickFire'
fi

echo "Copying SlickCold and SlickFire to /usr/share/themes..."
$SUID_PROG cp -r SlickCold SlickFire '/usr/share/themes'
echo "Done."
