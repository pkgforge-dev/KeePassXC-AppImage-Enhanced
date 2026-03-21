#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q keepassxc | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/keepassxc.png
export DESKTOP=/usr/share/applications/org.keepassxc.KeePassXC.desktop
export ALWAYS_SOFTWARE=1

# on archlinux qt5-wayland also adds the server side plugins
# remove them so that they do not get deployed
rm -rf /usr/lib/qt/plugins/wayland-graphics-integration-server

# Deploy dependencies
quick-sharun \
	/usr/bin/keepassxc* \
	/usr/lib/keepassxc  \
	/usr/lib/libpcsclite_real.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
