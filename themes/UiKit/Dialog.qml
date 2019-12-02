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

import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.0

T.Dialog {
    id: control

    property var applicationwindow: ApplicationWindow
    property alias shaderSourceItem: shader.sourceItem

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            header && header.visible ? header.implicitWidth : 0,
                            footer && footer.visible ? footer.implicitWidth : 0,
                            contentWidth > 0 ? contentWidth + leftPadding + rightPadding : 0)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             (header && header.visible ? header.implicitHeight + spacing : 0)
                             + (footer && footer.visible ? footer.implicitHeight + spacing : 0)
                             + (contentHeight > 0 ? contentHeight + topPadding + bottomPadding : 0))

    contentWidth: contentItem.implicitWidth || (contentChildren.length === 1 ? contentChildren[0].implicitWidth : 0)
    contentHeight: contentItem.implicitHeight || (contentChildren.length === 1 ? contentChildren[0].implicitHeight : 0)

    padding: 5
    leftPadding: 10
    rightPadding: 10

    parent: control.modal ? control.applicationwindow.overlay : control.parent

    background: Rectangle {
        color: UiKit.popup_background
//        border.color: UiKit.border_color
        radius: control.modal ? UiKit.radius_popup : UiKit.radius

        FastBlur {
            id: fastBlur

            visible: control.modal
            anchors.fill: parent
            radius: 100
            opacity: 0.2

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    x: fastBlur.x
                    y: fastBlur.y

                    width: fastBlur.width
                    height: fastBlur.height
                    radius: control.background.radius
                }
            }

            property int header_height: control.applicationwindow.header && control.applicationwindow.header.height ? control.applicationwindow.header.height : 0
            source: ShaderEffectSource {
                id: shader
                anchors.fill: parent
                sourceItem: control.applicationwindow.contentItem
                sourceRect: Qt.rect(control.x, control.y - fastBlur.header_height, control.background.width, control.background.height)
            }
        }
    }

    header: Label {
        text: control.title
        visible: control.title

        horizontalAlignment: Label.AlignHCenter
        elide: Label.ElideRight
        font.bold: true
        padding: 10

        clip: true
        background: Rectangle {
            id: labelBackground
            width: parent.width
            height: parent.height
            color: "transparent"

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    x: header.x
                    y: header.y

                    width: labelBackground.width
                    height: labelBackground.height
                    radius: control.background.radius
                }
            }
        }
    }

    enter: Transition {
        // grow_fade_in
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    exit: Transition {
        // shrink_fade_out
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    footer: DialogButtonBox {
        visible: count > 0
    }

    T.Overlay.modal: Rectangle {
        color: Color.transparent(control.palette.shadow, 0.5)
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    T.Overlay.modeless: Rectangle {
        color: Color.transparent(control.palette.shadow, 0.12)
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
}
