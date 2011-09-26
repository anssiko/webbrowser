Web [Browser]
================

A fork of the Qt/QML web browser demo (http://qt.gitorious.org/qt/qt/trees/4.7/demos/declarative/webbrowser).

Installation
================

Symbian Belle
----------------

* Install build/{yyyy-mm-dd}-web-symbian-belle.sis

(Symbian Belle devices contain Qt 4.7.4 and Qt Mobility 1.2.1 libraries as part of device firmware)

Symbian^3
----------------

* Install Qt 4.7.3 (qt.sis) and QtWebKit (qtwebkit.sis) e.g. from http://fixqt.com/
* Install build/{yyyy-mm-dd}-web-symbian3.sis

Maemo 5
----------------

* Make sure you have the Maemo 5 PR1.3 update
* Install build/{yyyy-mm-dd}-web-maemo5.deb

Features
================

Features inherited from Qt:

* Standards-compliant (see: html5test.com, acid3.acidtests.org, modernizr.com)
* Cross-platform (mobile: Symbian^3, Symbian^1, Maemo 5; desktop: OS X, Linux, Windows)

Features added on top of the demo web browser:

* Simpler user interface
* Keyboard navigation and shortcuts (backspace, arrow keys ...)
* Support for portrait and landscape modes (Maemo, Symbian)
* Search integration into location bar
* Some other things I've forgotten to add to this list :)

Things to Do
================

* Start page
* Pinch gesture support via [PinchArea](http://doc.qt.nokia.com/4.7-snapshot/qml-pincharea.html)
* Navigation history tree visualization

Known Issues
================

Some.