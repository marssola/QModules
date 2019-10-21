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
import QtQuick.Templates 2.4 as T
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

T.CheckDelegate {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 12
    spacing: 8

    icon.width: 24
    icon.height: 24
    icon.color: control.palette.text

    opacity: enabled ? 1 : 0.5

    contentItem: IconLabel {
        leftPadding: control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: !control.mirrored ? control.indicator.width + control.spacing : 0

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: control.display === IconLabel.IconOnly || control.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        color: control.palette.text
    }

    // keep in sync with CheckBox.qml (shared CheckIndicator.qml was removed for performance reasons)
    indicator: Rectangle {
        implicitWidth: 28
        implicitHeight: 28

        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        color: control.checkState === Qt.Checked ? control.palette.button : "transparent"
        border.color: control.checkState === Qt.Checked ? control.palette.button : UiKit.border_color
        radius: control.width / 2

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }

        Rectangle {
            x: (indicator.width / 2) - (width / 2)
            y: (indicator.height / 2) - (height / 2)
            width: (indicator.width / 2)
            height: 2

            visible: control.checkState === Qt.PartiallyChecked
        }

        Rectangle {
            x: (indicator.width / 2) - height
            y: (indicator.height / 2) / 2 + height
            width: 2
            height: indicator.height * 0.21
            rotation: -45

            visible: control.checkState === Qt.Checked
        }

        Rectangle {
            x: (indicator.width / 2) - width + (height / 3) - 2
            y: (indicator.height / 2) / 2
            width: 2
            height: indicator.height * 0.5
            rotation: 45

            visible: control.checkState === Qt.Checked
        }

        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 16
            height: 3
            color: control.palette.text
            visible: control.checkState === Qt.PartiallyChecked
        }
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: UiKit.implicitHeight
        color: "transparent"
    }
}
