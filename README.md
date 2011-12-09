Web Browser
================

A fork of the [Qt/QML web browser demo](http://qt.gitorious.org/qt/qt/trees/4.7/demos/declarative/webbrowser) used as a playground for experimenting with new Web APIs.

In addition to the standard [QtWebKit features](http://trac.webkit.org/wiki/QtWebKit), this web browser implements the following extras:

* [Battery Status API](http://dev.w3.org/2009/dap/system-info/battery-status.html)

Some other features added on top of the demo web browser:

* Simpler user interface
* Keyboard navigation and shortcuts (backspace, arrow keys ...)
* Support for portrait and landscape modes
* Search integration into location bar

Installation
================

* The primary supported platform is MeeGo 1.2 Harmattan (Maemo 6), for others see Older versions
* Make sure you have installed the MeeGo 1.2 Harmattan PR1.1 update to the device
* Get Qt SDK 1.1.4 or later (http://qt.nokia.com/downloads/), put your device into SDK mode, build and deploy as usual

* Alternatively, some (typically older) pre-built binaries are available at: build/{yyyy-mm-dd}-web-maemo6.deb

Older versions
=================

Older versions have been tested with the following platforms. Currently these platforms are unsupported.

Maemo 5
----------------

* Make sure you have installed the Maemo 5 PR1.3 update to the device
* Install build/{yyyy-mm-dd}-web-maemo5.deb

Symbian Belle
----------------

* No need to install any libraries, Symbian Belle devices contain Qt 4.7.4 and Qt Mobility 1.2.1 libraries as part of device firmware
* Install build/{yyyy-mm-dd}-web-symbian-belle.sis

Symbian^3
----------------

* Install Qt 4.7.3 (qt.sis) and QtWebKit (qtwebkit.sis) e.g. from http://fixqt.com/
* Install build/{yyyy-mm-dd}-web-symbian3.sis

Backlog
================

* [Vibration API](http://dev.w3.org/2009/dap/vibration/)
* Pinch gesture support via [PinchArea](http://doc.qt.nokia.com/4.7-snapshot/qml-pincharea.html)
* Navigation history tree visualization
* Start page