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
# The retroarch package has its own license (http://www.libretro.com/)
#
################################################################################

PKG_NAME="retroarch"
PKG_VERSION="git"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libretro.com"
PKG_URL=""
PKG_GIT_URL="git://github.com/libretro/libretro-super.git"
PKG_SOURCE_DIR="${PKG_NAME}-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain SDL"
PKG_PRIORITY="optional"
PKG_SECTION="plugin/program"
PKG_SHORTDESC="A frontend to libretro"
PKG_LONGDESC="RetroArch is an open-source project that makes use of a powerful development interface called Libretro. Libretro is an interface that allows you to make cross-platform applications that can use rich features such as OpenGL, cross-platform camera support, location support, and more in the future."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.python.pluginsource"

PKG_AUTORECONF="no"

pre_configure_target() {
  if ! [ -e libretro-fetch.sh ]; then
    git clone "$PKG_GIT_URL" .
    bash libretro-fetch.sh
  fi
}

make_target() {
  export CXX11="$CXX"
  if command -v nproc >/dev/null; then
    export JOBS=$(nproc)
  else
  export JOBS=1
  fi
  case "$ARCH" in
    x86_64)
    export X86=true
    export X86_64=true
    ;;
  i686)
    export X86=true
    ;;
  arm)
    export ARM=true
  ARCH=armv6l
  export ARM_HARDFLOAT=1
  ;;
  armv4l)
    export ARM=true
  export ARM_SOFTFLOAT=1
  ;;
  armv7l)
    export ARM=true
  export ARM_HARDFLOAT=1
  export ARM_NEON=1
  ;;
  armv*)
    export ARM=true
  export ARM_HARDFLOAT=1
  ;;
  esac
  export BUILD_LIBRETRO_GL=1
  export FORMAT_EXT='so'
  export FORMAT_COMPILER_TARGET=unix
  export DIST_DIR=unix
  export FORMAT_COMPILER_TARGET_ALT="$FORMAT_COMPILER_TARGET"
  export RARCH_DIST_DIR="$INSTALL/lib"

  pushd . &>/dev/null
  echo "Building libretro common"
  . ./libretro-build-common.sh

  for core in \
    build_libretro_dosbox \
    build_libretro_yabause \
    build_libretro_prboom \
    build_libretro_beetle_psx \
    build_libretro_beetle_pce_fast \
    build_libretro_bluemsx \
    build_libretro_genesis_plus_gx \
    build_libretro_snes9x \
    build_libretro_snes9x_next \
    build_libretro_fmsx \
    build_libretro_bsnes \
    build_libretro_bsnes_mercury \
    build_libretro_beetle_lynx \
    build_libretro_beetle_gba \
    build_libretro_beetle_ngp \
    build_libretro_beetle_supergrafx \
    build_libretro_beetle_pcfx \
    build_libretro_beetle_vb \
    build_libretro_beetle_wswan \
    build_libretro_beetle_snes \
    build_libretro_fb_alpha \
    build_libretro_picodrive \
    build_libretro_vbam \
    build_libretro_vba_next \
    build_libretro_bnes \
    build_libretro_fceumm \
    build_libretro_gambatte \
    build_libretro_meteor \
    build_libretro_nx \
    build_libretro_stella \
    build_libretro_quicknes \
    build_libretro_nestopia \
    build_libretro_handy \
    build_libretro_desmume \
    build_libretro_vecx \
    build_libretro_tgbdual \
    build_libretro_prosystem \
    build_libretro_dinothawr \
    build_libretro_virtualjaguar \
    build_libretro_3dengine \
    build_libretro_ppsspp \
    build_libretro_o2em \
    build_libretro_2048 \
  ; do
  pushd . &>/dev/null
    $core &
  sleep 1
  popd &>/dev/null
  done
  wait

  popd &>/dev/null

  echo "Building retroarch"
  cd retroarch
  ./configure --enable-sdl --disable-sdl2 --enable-udev --disable-ffmpeg --disable-netplay --disable-xinerama --disable-cg --enable-alsa --disable-oss --disable-rsound --disable-roar --disable-al --disable-jack --disable-pulse --disable-python
  make -f Makefile platform=unix -j$JOBS
  cd ..
}

makeinstall_target() {
  cd retroarch
  make -f Makefile platform=unix DESTDIR="$INSTALL" PREFIX="" MAN_DIR="/share/man/man1/" install
  cd ..
}

addon() {
  DESTDIR="$ADDON_BUILD/$PKG_ADDON_ID"

  # Copy frontend
  mkdir -p "$DESTDIR/libexec"
  cp "$PKG_BUILD/.install_pkg/bin/retroarch" "$DESTDIR/libexec"

  # Copy cores
  mkdir -p "$DESTDIR/lib"
  cp "$PKG_BUILD/.install_pkg/lib/"*_libretro.so "$DESTDIR/lib"

  # Generate core frontends
  mkdir -p "$DESTDIR/bin"
  for c in "$PKG_BUILD/.install_pkg/lib"/*_libretro.so; do
    core="$(basename "$c" _libretro.so)"
    cat > "$DESTDIR/bin/retroarch-$core" <<EOF
#!/bin/bash
. "\$(dirname "\$0")"/../libexec/retroarch-common.sh $core "$@"
EOF
    chmod a+x "$DESTDIR/bin/retroarch-$core"
  done
}

