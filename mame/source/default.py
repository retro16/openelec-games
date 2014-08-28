"""
    Plugin for Launching MAME
"""

# -*- coding: UTF-8 -*-
# main imports
import sys 
import os

# plugin constants
__plugin__ = "MAME"
__author__ = "Retro16"
__url__ = "http://www.mamedev.org/"
__git_url__ = "https://github.com/retro16/openelec-games"
__credits__ = ""
__version__ = "4.1.0"

if ( __name__ == "__main__" ):
    # Ensure files are executable

    mameexec = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'bin', 'mame')
    mamebin = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'libexec', 'mame')

    os.chmod(mameexec, 0755)
    os.chmod(mamebin, 0755)

    os.system(mameexec)

