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
import "js/webbrowser.js" as JS

Image {
    id: header

    property alias editUrl: urlInput.url
    property bool urlChanged: false
    property bool reloadVisible: false

    source: webBrowser.theme.titleBarBackground
    fillMode: Image.TileHorizontally

    x: webView.contentX < 0 ? -webView.contentX : webView.contentX > webView.contentWidth-webView.width
       ? -webView.contentX+webView.contentWidth-webView.width : 0
    y: {
        if (webView.progress < 1.0)
            return 0;
        else {
            webView.contentY < 0 ? -webView.contentY : webView.contentY > height ? -height : -webView.contentY
        }
    }
    Column {
        width: parent.width

        Item {
            width: parent.width; height: 25
            Text {
                anchors.centerIn: parent
                text: webView.title; font.pixelSize: 18; font.bold: false
                color: webBrowser.theme.titleTextColor; styleColor: webBrowser.theme.titleTextStyleColor; style: Text.Sunken
            }
        }

        Item {
            width: parent.width; height: 40

            Button {
                id: backButton
                anchors { left: parent.left; bottom: parent.bottom; leftMargin: 15 }
                action: webView.back; image: webBrowser.theme.backButton
                animation: "back"
            }

            Button {
                id: nextButton
                anchors { left: backButton.right; leftMargin: 15 }
                action: webView.forward; image: webBrowser.theme.forwardButton
                animation: "next"
            }

            Button {
                id: reloadButton
                anchors { left: nextButton.right; leftMargin: 20 }
                onClicked: { webBrowser.urlString = editUrl }
                action: webView.reload; image: webBrowser.theme.reloadButton
                visible: isReloadVisible()
                animation: "reload"
                function isReloadVisible() {
                    if (webView.progress == 1.0) return true;
                    if (action != undefined) {
                        return (action.enabled) ? true : false;
                    } else return true;
                }
            }

            Button {
                id: stopButton
                anchors { left: nextButton.right; leftMargin: 20 }
                action: webView.stop; image: webBrowser.theme.stopButton
                visible: !reloadButton.visible
                animation: "stop"
            }

            UrlInput {
                id: urlInput
                anchors { left: reloadButton.right; right: quitButton.left; rightMargin: 10 }
                image: webBrowser.theme.urlInput
                onUrlEntered: {
                    webBrowser.urlString = url
                    webBrowser.focus = true
                    header.urlChanged = false
                }
                onUrlChanged: header.urlChanged = true
            }

            Button {
                id: goButton
                anchors { right: quitButton.left; rightMargin: 15 }
                onClicked: {
                    webBrowser.urlString = urlInput.url
                    webBrowser.focus = true
                    header.urlChanged = false
                }
                image: webBrowser.theme.goButton; visible: header.urlChanged
            }

            Button {
                id: quitButton
                anchors { right: parent.right; rightMargin: 10 }
                image: webBrowser.theme.quitButton
                onClicked: Qt.quit()
            }

        }
    }

}
