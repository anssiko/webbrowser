#!/bin/sh
rm -rf webbrowser.app
make clean
qmake
make
make clean
open webbrowser.app