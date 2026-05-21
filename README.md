SlickCold and SlickFire GTK3+ Themes
====================================

SlickCold is complete rewrite of OriginalSeed's [DarkCold](https://github.com/originalseed/darkcold) GTK theme from scratch in sass, with some assests reused.
SlickFire is generated from SlickCold based on infinity0's [DarkFire](https://github.com/infinity0/dark-themes) script.

These themes were designed and only tested on MATE, though feel free to report if anything seems broken on other DEs.

The `gtk-2.0` directory is mostly untouched and is kept for legacy compatibilty.

Installation
============
```
git clone https://github.com/Mystia-Izakaya/slick-gtk-themes
cd slick-gtk-themes
./generate.sh
mv SlickCold SlickFire ~/.themes
```

Extras
======

Theming Firefox and its forks
-----------------------------
A `chrome.css` is generated inside each theme directory, this is meant to be used with with Aris-t2's [Custom CSS for Firefox](https://github.com/Aris-t2/CustomCSSforFx), import it at the end of `userChrome.css`. See that repo for more details on theming Firefox with CSS.

Theming GIMP
------------
GIMP has styles that override the system theme, to fix this create an empty style to be used by GIMP like so:
```
sudo mkdir /usr/share/gimp/3.0/themes/NoOverrides
sudo touch /usr/share/gimp/3.0/themes/NoOverrides/gimp.css
```
Now Open GIMP, go to Edit > Preferences > Interface > Theme > Select NoOverrides and reload your theme.

Theming Inkscape
----------------
Inkscape also tries to override the system theme, however it seems to do so less agressively than GIMP.
Inkscape override the system theme by `/usr/share/inkscape/ui/style.css` which is then overriden by `/usr/share/inkscape/ui/user.css`.
For inkscape, the only modification needed is to restore borders around buttons:
```
echo "button { border: solid black 1px; }" | sudo tee /usr/share/inkscape/ui/user.css
```

Emerald theme
-------------
Included is also two emerald themes inside `./emerald-themes` to be used with the Emerald window decorator, import the themes from Emerald Theme Manager. These themes are also based on OriginalSeed's DarkCold emerald theme.
