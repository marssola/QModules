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
import QtGraphicalEffects 1.0

T.SwitchDelegate {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 12
    spacing: 12

    icon.width: 24
    icon.height: 24
    icon.color: control.palette.text

    opacity: enabled ? 1 : 0.5

    indicator: PaddedRectangle {
        implicitWidth: 45
        implicitHeight: UiKit.implicitHeight

        x: text ? (control.mirrored ? control.leftPadding : control.width - width - control.rightPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2

        radius: width / 2
        leftPadding: 0
        rightPadding: 0
        padding: height * 0.05
        color: control.checked ? UiKit.green : UiKit.component_border_color
        border.width: 1
        border.color: control.checked ? UiKit.green : UiKit.component_border_color

        Rectangle {
            x: Math.max(0, Math.min(parent.width - width - 1, control.visualPosition * parent.width + 15 - (width / 2)))
            y: (parent.height - height) / 2
            width: UiKit.implicitHeight * 0.83
            height: width
            radius: width / 2
            color: UiKit.white
//            border.width: 0.8
//            border.color: control.checked ? UiKit.component_border_color : UiKit.border_lighter_color

            Behavior on x {
                enabled: !control.down
                SmoothedAnimation { velocity: 200 }
            }

//            layer.enabled: !control.checked
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 8
                color: UiKit.border_lighter_color
            }
        }
    }

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

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: UiKit.implicitHeight
        color: "transparent"
    }
}
