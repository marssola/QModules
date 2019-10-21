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
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import QtQuick.Templates 2.4 as T
import QtGraphicalEffects 1.0

T.ComboBox {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    opacity: control.enabled ? 1 : 0.5

    delegate: ItemDelegate {
        width: parent.width
        height: UiKit.implicitHeight
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: Item {
        x: control.mirrored ? control.padding - 5 : control.width - width - control.padding - 5
        y: control.topPadding + (control.availableHeight - height) / 2
        width: height
        height: 30 * 0.5

        rotation: popup.visible? 180 : 0

        Rectangle {
            x: width * 0.20
            y: parent.height /2
            width: parent.width * 0.5
            height: 2
            border.color: control.activeFocus ? control.palette.highlight : UiKit.border_color

            radius: 5
            rotation: 45
        }

        Rectangle {
            x: width * 0.85
            y: parent.height /2
            width: parent.width * 0.5
            height: 2
            border.color: control.activeFocus ? control.palette.highlight : UiKit.border_color

            radius: 5
            rotation: -45
        }

        Behavior on rotation {
            NumberAnimation {
                duration: 150
            }
        }
    }

    contentItem: T.TextField {
        leftPadding: !control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        topPadding: 6 - control.padding
        bottomPadding: 6 - control.padding

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator

        font: control.font
        color: control.editable ? control.palette.text : control.palette.buttonText
        selectionColor: control.palette.highlight
        selectedTextColor: control.palette.highlightedText
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: UiKit.implicitHeight

        visible: !control.flat || control.down
        color: control.palette.base
        border.color: control.activeFocus ? control.palette.highlight : UiKit.border_color
        border.width: control.flat ? 0 : 1
        radius: UiKit.radius
    }

    popup: T.Popup {
        y: control.height
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        topMargin: 6
        bottomMargin: 6

        contentItem: ListView {
            implicitHeight: contentHeight
            highlightMoveDuration: 0

            model: control.delegateModel
            currentIndex: control.highlightedIndex

            clip: true
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    x: rectBackground.x
                    y: rectBackground.y

                    width: rectBackground.width
                    height: rectBackground.height
                    radius: rectBackground.radius
                }
            }

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        transformOrigin: Item.Center
        enter: Transition {
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }
        exit: Transition {
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        background: Rectangle {
            id: rectBackground
            color: control.palette.base
            radius: UiKit.radius
            border.color: UiKit.border_color

            RectangularGlow {
                width: parent.width
                height: parent.height

                glowRadius: 5
                spread: 0
                color: UiKit.border_color
                cornerRadius: 5
            }
        }
    }
}
