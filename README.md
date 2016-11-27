Project closed
==============

Due to the fact that I don't use OpenELEC anymore, I won't maintain it anymore.

This project is left open for archive purposes only, feel free to fork but don't expect any maintenance.

openelec-games
==============

Retro gaming extensions for OpenELEC.

These extensions provide games for the [OpenELEC.tv][1] linux
distribution compiled as XBMC/Kodi extensions. Extensions allow easy
installation and removal for the end-user.

These extensions are for use only in OpenELEC. The binaries are built
specifically for this distribution and many assumptions about internal
paths are done inside wrapper scripts. Porting these extentions to other
distributions/platforms would be a lot of work.


Supported programs
------------------

 * [MAME][2] : The Multiple Arcade Machine Emulator,
   with its default SDL interface.

 * [Retroarch][3] : RetroArch is an open-source
   project that makes use of a powerful development interface called
   Libretro. Libretro is an interface that allows you to make
   cross-platform applications that can use rich features such as
   OpenGL, cross-platform camera support, location support, and more in
   the future.


Supported platforms
-------------------

Currently, the only supported platform is the Generic x86_64 build of
OpenELEC. It should be possible to adapt it for the Raspberry PI build.


Setting up openelec-games
-------------------------

 * Download the [precompiled ZIP files][4]
 * Copy the ZIP files to a USB drive (or any location reachable from
   XBMC)
 * Inside XBMC, go to settings / extensions and choose "Install from ZIP
   file"
 * Choose the previously downloaded ZIP file
 * The extension appears in the "Programs" menu and can be launched
   directly.
 * When the extension is launched, XBMC will stop, so it may be a bit
   slow. be patient.

The first time the extension is launched, a new configuration is created
and the 'emulators' directory is populated in the storage directory. You
will be able to put ROMs there and access saves, savestates, ...


Building from source
--------------------

 * Clone the OpenELEC repository (adjust openelec-4.0 to the branch you wish) :

```
git clone -b openelec-4.0 https://github.com/OpenELEC/OpenELEC.tv.git
```

 * (optional) If you wish to build the whole distributions, refer to [instructions to build OpenELEC][5]

 * cd into the OpenELEC root directory

 * Fetch the openelec-games repository. If you built OpenELEC from source, you can use ''git submodule'' :
  
```
git submodule add https://github.com/retro16/openelec-games.git packages/openelec-games
```
 * Install build dependencies on your distribution. For Debian, you can run this command :

```
apt-get install build-essential automake gawk git texinfo gperf cvs xsltproc libncurses5-dev libxml-parser-perl unzip zip xfonts-utils wget libsdl1.2-dev libsdl-ttf2.0-dev bc default-jre-headless fontconfig libfontconfig1-dev libxinerama-dev
```

 * Build each addon with the following commands :

```
ARCH=x86_64 scripts/create_addon mame
ARCH=x86_64 scripts/create_addon retroarch
```

 * Zip files are generated in the target/addon subdirectory



[1]: http://openelec.tv "Official OpenELEC.tv website"
[2]: http://mamedev.org "Official MAME website"
[3]: http://libretro.com "Official libretro/retroarch website"
[4]: http://coulon-jm.fr/openelec-games "Pre-compiled binaries"
[5]: http://wiki.openelec.tv/index.php?title=Compile_from_source "OpenELEC: Compile from source"
