################################################################################
#      This file is NOT part of OpenELEC - http://www.openelec.tv
#
# This package is under the MIT License (MIT).
#
# Copyright (c) 2014 Jean-Matthieu COULON
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# The MAME source code has its own license (http://www.mamedev.org/legal.html).
#
################################################################################

# To build, you must install these packages on the host in order to compile code generators :
# libsdl1.2-dev libsdl-ttf2.0-dev libfontconfig1-dev libxinerama-dev

PKG_NAME="mame"
PKG_VERSION="154"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://mamedev.org"
PKG_URL="http://whiper.com/mame/${PKG_VERSION}/${PKG_NAME}0${PKG_VERSION}s.zip"
PKG_DEPENDS_TARGET="toolchain SDL SDL_ttf font-util fontconfig libXinerama"
PKG_PRIORITY="optional"
PKG_SECTION="plugin/program"
PKG_SHORTDESC="MAME (Version: $PKG_VERSION): The Multiple Arcade Machine Emulator."
PKG_LONGDESC="MAME (Version: $PKG_VERSION) MAME stands for Multiple Arcade Machine Emulator. When used in conjunction with images of the original arcade game's ROM and disk data, MAME attempts to reproduce that game as faithfully as possible on a more modern general-purpose computer. MAME can currently emulate several thousand different classic arcade video games from the late 1970s through the modern era."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.pluginsource"
PKG_ADDON_REQUIRES="script.module.SDL_ttf:4.1.0"
PKG_AUTORECONF="no"
PKG_SOURCE_DIR="${PKG_NAME}"

unpack() {
  unzip -o "$SOURCES/${PKG_NAME}/${PKG_NAME}0${PKG_VERSION}s.zip" -d "$BUILD/${PKG_NAME}"
  unzip -o "$BUILD/${PKG_NAME}/${PKG_NAME}.zip" -d "$BUILD/${PKG_NAME}"
  rm "$BUILD/${PKG_NAME}/${PKG_NAME}.zip"
}

make_target() {
  mkdir -p $PWD/native_obj/build
  make $PKG_MAKE_OPTS_HOST CC="${HOST_CC}" LD="${HOST_CXX}" AS="${HOST_AS}" AR="${HOST_AR}" NM="${HOST_NM}" RANLIB="${HOST_RANLIB}" OBJCOPY="${HOST_OBJCOPY}" STRIP="${HOST_STRIP}" OSD=sdl NATIVE_OBJ=$PWD/native_obj NO_USE_QTDEBUG=1 NO_USE_MIDI=1 NOWERROR=1 LDFLAGS=-lSDL buildtools

  if [ "$ARCH" = "x86_64" ]; then PTR64=1; else PTR64=0; fi

  make LD="${TARGET_CXX}" LDFLAGS= NATIVE_OBJ=$PWD/native_obj SDL_INSTALL_ROOT="${ROOT}/${TOOLCHAIN}" NO_USE_QTDEBUG=1 NO_USE_MIDI=1 NOWERROR=1 CROSS_COMPILE=1 PTR64=$PTR64
}

makeinstall_target() {
  :
}

addon() {
  DESTDIR="$ADDON_BUILD/$PKG_ADDON_ID"

  # Copy binary
  mkdir -p "$DESTDIR/libexec"
  cp "$PKG_BUILD/"mame* "$DESTDIR/libexec/mame"
}
