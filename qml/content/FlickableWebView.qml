/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the QtDeclarative module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import QtWebKit 1.0
import "js/webbrowser.js" as JS

Flickable {
    property alias title: viewport.title
    property alias icon: viewport.icon
    property alias progress: viewport.progress
    property alias url: viewport.url
    property alias back: viewport.back
    property alias stop: viewport.stop
    property alias reload: viewport.reload
    property alias forward: viewport.forward

    property alias viewportInstance: viewport

    id: flickable
    width: parent.width
    contentWidth: Math.max(parent.width,viewport.width)
    contentHeight: Math.max(parent.height,viewport.height)
    anchors.top: headerSpace.bottom
    anchors.bottom: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    pressDelay: 200

    onWidthChanged : {
        // Expand (but not above 1:1) if otherwise would be smaller that available width.
        if (width > viewport.width*viewport.contentsScale && viewport.contentsScale < 1.0)
            viewport.contentsScale = width / viewport.width * viewport.contentsScale;
    }

    WebView {
        id: viewport
        settings.pluginsEnabled: false
        transformOrigin: Item.TopLeft
        smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
        focus: true

        property double level: 1.0
        property bool charging: true

        javaScriptWindowObjects: [
            QtObject {
                WebView.windowObjectName: "debug"
                function battery(level, charging) {
                    return "{ level: " + level  + ", charging: " + charging + " }";
                }
            },
            QtObject {
                WebView.windowObjectName: "console"
                function log(msg) {
                    console.log('console.log: ' + msg);
                }
            }
        ]

        onLoadFinished: {
            viewport.evaluateJavaScript(
            "(function(n) {" +
            "    n.battery = {" +
            "        charging: " + charging + "," +
            "        chargingTime: Infinity," +
            "        dischargingTime: Infinity," +
            "        level: " + level + "," +
            "        onchargingchange: null," +
            "        onchargingtimechange: null," +
            "        ondischargingtimechange: null," +
            "        onlevelchange: null," +
                     // EventTarget interface
                     // TODO: implement support for multiple event listeners, event capture, Event interface
            "        addEventListener: function (type, listener, capture) {" +
            "            if (listener === null) return;" +
            "            navigator.battery['on' + type] = function () { listener({ type: type }) };" +
            "        }," +
            "        removeEventListener: function (type, listener, capture) {" +
            "            navigator.battery['on' + type] = null;" +
            "        }" +
            "    };" +
            "    n.mozBattery = n.battery;" +
            "})(window.navigator);" +
            "document.title = debug.battery(navigator.battery.level, navigator.battery.charging);")
        }

        onLevelChanged: {
            viewport.evaluateJavaScript(
            "navigator.battery.level = " + level + ";" +
            "document.title = debug.battery(navigator.battery.level, navigator.battery.charging);" +
            "if (typeof navigator.battery.onlevelchange === 'function') navigator.battery.onlevelchange();" +
            "")
        }

        onChargingChanged: {
            viewport.evaluateJavaScript(
            "navigator.battery.charging = " + charging + ";" +
            "document.title = debug.battery(navigator.battery.level, navigator.battery.charging);" +
            "if (typeof navigator.battery.onchargingchange === 'function') navigator.battery.onchargingchange();" +
            "")
        }

        onAlert: console.log("alert('" + message + "')")

        function doZoom(zoom,centerX,centerY) {
            if (centerX) {
                var sc = zoom*contentsScale;
                scaleAnim.to = sc;
                flickVX.from = flickable.contentX
                flickVX.to = Math.max(0,Math.min(centerX-flickable.width/2,viewport.width*sc-flickable.width))
                finalX.value = flickVX.to
                flickVY.from = flickable.contentY
                flickVY.to = Math.max(0,Math.min(centerY-flickable.height/2,viewport.height*sc-flickable.height))
                finalY.value = flickVY.to
                quickZoom.start()
            }
        }

        Keys.onLeftPressed: zoomOut.start()
        Keys.onRightPressed: zoomIn.start()
        Keys.onUpPressed: scrollUp.start()
        Keys.onDownPressed: scrollDown.start()
        Keys.onSpacePressed: scrollPageDown.start()
        Keys.onPressed: JS.onKeyPressed(event)

        preferredWidth: flickable.width
        preferredHeight: flickable.height
        contentsScale: 1
        onContentsSizeChanged: {
            // zoom out
            contentsScale = Math.min(1,flickable.width / contentsSize.width)
        }
        onUrlChanged: {
            // got to topleft
            flickable.contentX = 0
            flickable.contentY = 0
            if (url != null) header.editUrl = JS.getPrettyUrl(url)
        }
        onDoubleClick: {
            if (!heuristicZoom(clickX,clickY,2.5)) {
                var zf = flickable.width / contentsSize.width
                if (typeof zoomFactor != "undefined" && zf >= contentsScale)
                    zf = 2.0/zoomFactor // zoom in (else zooming out)
                else if (typeof zoomFactor === "undefined")
                    zf = 1 // no zoom
                doZoom(zf,clickX*zf,clickY*zf)
             }
        }

        SequentialAnimation {
            id: quickZoom

            PropertyAction {
                target: viewport
                property: "renderingEnabled"
                value: false
            }
            ParallelAnimation {
                NumberAnimation {
                    id: scaleAnim
                    target: viewport
                    property: "contentsScale"
                    // the to property is set before calling
                    easing.type: Easing.Linear
                    duration: 200
                }
                NumberAnimation {
                    id: flickVX
                    target: flickable
                    property: "contentX"
                    easing.type: Easing.Linear
                    duration: 200
                    from: 0 // set before calling
                    to: 0 // set before calling
                }
                NumberAnimation {
                    id: flickVY
                    target: flickable
                    property: "contentY"
                    easing.type: Easing.Linear
                    duration: 200
                    from: 0 // set before calling
                    to: 0 // set before calling
                }
            }
            // Have to set the contentXY, since the above 2
            // size changes may have started a correction if
            // contentsScale < 1.0.
            PropertyAction {
                id: finalX
                target: flickable
                property: "contentX"
                value: 0 // set before calling
            }
            PropertyAction {
                id: finalY
                target: flickable
                property: "contentY"
                value: 0 // set before calling
            }
            PropertyAction {
                target: viewport
                property: "renderingEnabled"
                value: true
            }
        }
        onZoomTo: doZoom(zoom,centerX,centerY)

        SequentialAnimation {
            id: scrollDown; running: false
            PropertyAction { target: viewport; property: "renderingEnabled"; value: false }
            NumberAnimation { target: flickable; duration: 100; easing.type: Easing.Linear; property: "contentY"; from: flickable.contentY;
                to: {
                    if (flickable.contentY < flickable.contentHeight - webBrowser.height) return flickable.contentY + 200
                    else return flickable.contentHeight - webBrowser.height
                }
            }
            PropertyAction { target: viewport; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: scrollUp; running: false
            PropertyAction { target: viewport; property: "renderingEnabled"; value: false }
            NumberAnimation { target: flickable; duration: 100; easing.type: Easing.Linear; property: "contentY"; from: flickable.contentY;
                to: {
                    if (flickable.contentY > 0) return flickable.contentY - 200
                    else return 0
                }
            }
            PropertyAction { target: viewport; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: scrollPageDown; running: false
            PropertyAction { target: viewport; property: "renderingEnabled"; value: false }
            NumberAnimation { target: flickable; duration: 100; easing.type: Easing.Linear; property: "contentY"; from: flickable.contentY;
                to: {
                    if (flickable.contentY < flickable.contentHeight - webBrowser.height) return flickable.contentY + webBrowser.height
                    else return flickable.contentHeight - webBrowser.height
                }
            }
            PropertyAction { target: viewport; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: zoomOut; running: false
            PropertyAction { target: viewport; property: "renderingEnabled"; value: false }
            NumberAnimation { target: viewport; duration: 100; easing.type: Easing.Linear; property: "contentsScale"; from: viewport.contentsScale;
                to: {
                    if (viewport.contentsScale > 0.5) return viewport.contentsScale - 0.25
                    else return 0.5
                }
            }
            PropertyAction { target: viewport; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: zoomIn; running: false
            PropertyAction { target: viewport; property: "renderingEnabled"; value: false }
            NumberAnimation { target: viewport; duration: 100; easing.type: Easing.Linear; property: "contentsScale"; from: viewport.contentsScale;
                to: {
                    if (viewport.contentsScale < 1.5) return viewport.contentsScale + 0.25
                    else return 1.5
                }
            }
            PropertyAction { target: viewport; property: "renderingEnabled"; value: true }
        }
    }

}
