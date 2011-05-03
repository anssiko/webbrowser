rm -rf webbrowser.app
make clean
qmake
make
open webbrowser.app