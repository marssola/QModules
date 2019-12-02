/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import QtQuick.Templates 2.4 as T

T.BusyIndicator {
    id: control

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    padding: 2
    contentItem: Item {
        id: item
        implicitWidth: 32
        implicitHeight: 32

        opacity: control.running ? 1 : 0

        Behavior on opacity {
            OpacityAnimator {
                duration: 250
            }
        }

        RotationAnimator {
            target: item
            running: control.visible && control.running
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }

        Repeater {
            id: repeater
            model: 8

            Rectangle {
                x: item.width / 2 - width / 2
                y: item.height / 2 - height / 2
                implicitWidth: 2
                implicitHeight: 10
                color: control.palette.windowText
                radius: 5

                transform: [
                    Translate {
                        y: -10
                    },
                    Rotation {
                        angle: index / repeater.count * 360
                        origin.x: 1
                        origin.y: 5
                    }
                ]
            }
        }
    }
}
