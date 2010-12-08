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

import Qt 4.7
import QtWebKit 1.0
import "../js/webbrowser.js" as JS


Flickable {
    property alias title: webView.title
    property alias icon: webView.icon
    property alias progress: webView.progress
    property alias url: webView.url
    property alias back: webView.back
    property alias stop: webView.stop
    property alias reload: webView.reload
    property alias forward: webView.forward

    id: flickable
    width: parent.width
    contentWidth: Math.max(parent.width,webView.width)
    contentHeight: Math.max(parent.height,webView.height)
    anchors.top: headerSpace.bottom
    anchors.bottom: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    pressDelay: 200

    onWidthChanged : {
        // Expand (but not above 1:1) if otherwise would be smaller that available width.
        if (width > webView.width*webView.contentsScale && webView.contentsScale < 1.0)
            webView.contentsScale = width / webView.width * webView.contentsScale;
    }

    WebView {
        id: webView
        transformOrigin: Item.TopLeft
        smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
        focus: true

        onAlert: console.log(message)

        function doZoom(zoom,centerX,centerY) {
            if (centerX) {
                var sc = zoom*contentsScale;
                scaleAnim.to = sc;
                flickVX.from = flickable.contentX
                flickVX.to = Math.max(0,Math.min(centerX-flickable.width/2,webView.width*sc-flickable.width))
                finalX.value = flickVX.to
                flickVY.from = flickable.contentY
                flickVY.to = Math.max(0,Math.min(centerY-flickable.height/2,webView.height*sc-flickable.height))
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
                if (zf >= contentsScale)
                    zf = 2.0/zoomFactor // zoom in (else zooming out)
                doZoom(zf,clickX*zf,clickY*zf)
             }
        }

        SequentialAnimation {
            id: quickZoom

            PropertyAction {
                target: webView
                property: "renderingEnabled"
                value: false
            }
            ParallelAnimation {
                NumberAnimation {
                    id: scaleAnim
                    target: webView
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
                target: webView
                property: "renderingEnabled"
                value: true
            }
        }
        onZoomTo: doZoom(zoom,centerX,centerY)

        SequentialAnimation {
            id: scrollDown; running: false
            PropertyAction { target: webView; property: "renderingEnabled"; value: false }
            NumberAnimation { target: flickable; duration: 100; easing.type: Easing.Linear; property: "contentY"; from: flickable.contentY;
                to: {
                    if (flickable.contentY < flickable.contentHeight - webBrowser.height) return flickable.contentY + 200
                    else return flickable.contentHeight - webBrowser.height
                }
            }
            PropertyAction { target: webView; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: scrollUp; running: false
            PropertyAction { target: webView; property: "renderingEnabled"; value: false }
            NumberAnimation { target: flickable; duration: 100; easing.type: Easing.Linear; property: "contentY"; from: flickable.contentY;
                to: {
                    if (flickable.contentY > 0) return flickable.contentY - 200
                    else return 0
                }
            }
            PropertyAction { target: webView; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: scrollPageDown; running: false
            PropertyAction { target: webView; property: "renderingEnabled"; value: false }
            NumberAnimation { target: flickable; duration: 100; easing.type: Easing.Linear; property: "contentY"; from: flickable.contentY;
                to: {
                    if (flickable.contentY < flickable.contentHeight - webBrowser.height) return flickable.contentY + webBrowser.height
                    else return flickable.contentHeight - webBrowser.height
                }
            }
            PropertyAction { target: webView; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: zoomOut; running: false
            PropertyAction { target: webView; property: "renderingEnabled"; value: false }
            NumberAnimation { target: webView; duration: 100; easing.type: Easing.Linear; property: "contentsScale"; from: webView.contentsScale;
                to: {
                    if (webView.contentsScale > 0.5) return webView.contentsScale - 0.25
                    else return 0.5
                }
            }
            PropertyAction { target: webView; property: "renderingEnabled"; value: true }
        }

        SequentialAnimation {
            id: zoomIn; running: false
            PropertyAction { target: webView; property: "renderingEnabled"; value: false }
            NumberAnimation { target: webView; duration: 100; easing.type: Easing.Linear; property: "contentsScale"; from: webView.contentsScale;
                to: {
                    if (webView.contentsScale < 1.5) return webView.contentsScale + 0.25
                    else return 1.5
                }
            }
            PropertyAction { target: webView; property: "renderingEnabled"; value: true }
        }
    }

}
