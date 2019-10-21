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
import QtGraphicalEffects 1.0

T.SpinBox {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + 2 * padding +
                            (up.indicator ? up.indicator.implicitWidth : 0) +
                            (down.indicator ? down.indicator.implicitWidth : 0))
    implicitHeight: Math.max(contentItem.implicitHeight + topPadding + bottomPadding,
                             background ? background.implicitHeight : 0,
                             up.indicator ? up.indicator.implicitHeight : 0,
                             down.indicator ? down.indicator.implicitHeight : 0)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 6
    leftPadding: padding
    rightPadding: up.indicator && down.indicator? (up.indicator.width + down.indicator.width): padding

    opacity: enabled ? 1 : 0.5
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput {
        z: 2
        text: control.displayText

        font: control.font
        color: control.palette.text
        selectionColor: control.palette.highlight
        selectedTextColor: control.palette.highlightedText
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints
    }

    up.indicator: Rectangle {
        x: parent.width - width
        implicitWidth: 50
        implicitHeight: UiKit.implicitHeight

        radius: control.background.radius
        color: up.pressed ? control.palette.button : "transparent"

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 3
            height: 2
            color: up.pressed ? UiKit.white : control.palette.button

            opacity: enabled ? 1 : 0.5
        }

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 2
            height: parent.width / 3
            color: up.pressed ? UiKit.white : control.palette.button

            opacity: enabled ? 1 : 0.5
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                x: control.background.x
                y: control.background.y

                width: control.background.width
                height: control.background.height
                radius: control.background.radius
            }
        }
    }

    down.indicator: Rectangle {
        x: parent.width - (width + down.indicator.width)
        implicitWidth: 50
        implicitHeight: UiKit.implicitHeight

        radius: control.background.radius
        color: down.pressed ? control.palette.button : "transparent"

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 3
            height: 2
            color: down.pressed ? UiKit.white : control.palette.button

            opacity: enabled ? 1 : 0.5
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                x: control.background.x
                y: control.background.y

                width: control.background.width
                height: control.background.height
                radius: control.background.radius
            }
        }
    }

    Rectangle {
        width: up.pressed ? 3 : 1
        height: control.background.height - 2

        x: up.indicator.x - 1
        y: 1
        color: control.palette.button
    }

    Rectangle {
        visible: down.pressed
        width: 3
        height: control.background.height - 1

        x: down.indicator.x + down.indicator.width - width
        y: 1
        color: control.palette.button
    }

    background: Rectangle {
        implicitWidth: 150
        width: (up.indicator.width + down.indicator.width)
        x: parent.width - width
        clip: true

        color: enabled ? "transparent" : control.palette.button
        border.color: control.palette.button
        radius: UiKit.radius
    }
}
