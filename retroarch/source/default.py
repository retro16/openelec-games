"""
    Dependency plugin
"""


# -*- coding: UTF-8 -*-
# main imports
import sys 
import os

# plugin constants
__plugin__ = "retroarch"
__author__ = "Retro16"
__url__ = "http://libretro.com"
__git_url__ = "git://github.com/libretro/libretro-super.git"
__credits__ = ""
__version__ = "4.1.0"

if ( __name__ == "__main__" ):
    raexec = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'bin', 'retroarch')
    os.chmod(raexec, 0755)
    os.system(raexec)

