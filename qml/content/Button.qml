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

Item {
    property alias image: icon.source
    property variant action
    property variant animation

    signal clicked

    width: 40; height: parent.height

    Image {
        id: icon; anchors.centerIn: parent
        opacity: if (action != undefined) { action.enabled ? 1.0 : 0.4 } else 1
        smooth: true
        // Extra Button animation run after default animation
        states: [
            State {
                name: "back";
                //PropertyChanges { target: icon; x: 100; y: 100 }
                PropertyChanges { target: icon; rotation: -360 }
            },
            State {
                name: "next";
                PropertyChanges { target: icon; rotation: 360 }
            },
            State {
                name: "reload";
                PropertyChanges { target: icon; rotation: 360 }
            },
            State {
                name: "stop";
            }
        ]
        transitions: [
            Transition {
                from: "*"; to: "back,next"
                NumberAnimation { properties: "rotation" }
            },
            Transition {
                from: "*"; to: "reload,stop"
                NumberAnimation { properties: "rotation,opacity" }
            }

        ]
    }

    MouseArea {
        id: buttonMouseArea
        anchors { fill: parent; topMargin: -10; bottomMargin: -10 }
        onClicked: {
            if (action != undefined) action.trigger();
            parent.clicked();
        }
        onReleased: {
            icon.state = ""
        }
    }

    // Button default animation
    states: [
        State {
            name: "pressed"
            when: buttonMouseArea.pressed == true
            PropertyChanges { target: icon; scale: 1.4 }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "pressed"
            reversible: true
            NumberAnimation { properties: "scale"; easing.type: Easing.InOutQuad }
        }
    ]

}
