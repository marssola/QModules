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

T.Button {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 6
    leftPadding: padding + 2
    rightPadding: padding + 2
    spacing: 6

    opacity: !control.enabled ? 0.5 : 1

    icon.width: 24
    icon.height: 24
    icon.color: control.checked || control.highlighted ? UiKit.white : !control.enabled ? UiKit.gray : control.down ? control.palette.dark : control.palette.button

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font
        color: control.checked || control.highlighted ? UiKit.white : !control.enabled ? UiKit.gray : control.down ? control.palette.dark : control.palette.button

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: UiKit.implicitHeight
        visible: !control.flat || control.checked || control.highlighted

        color: control.checked || control.highlighted ? !control.enabled ? UiKit.gray : control.down ? control.palette.dark : control.palette.button : "transparent"
        border.color: !control.enabled ? UiKit.gray : control.down ? control.palette.dark : control.palette.button
        border.width: control.flat ? 0 : 1
        radius: UiKit.radius

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }
}
