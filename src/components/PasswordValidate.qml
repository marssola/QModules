import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.13

import UiKit 1.0

T.ToolTip {
    id: tooltip

    x: parent ? ((parent.width + 20) - implicitWidth) / 2 : 0
    y: -implicitHeight - 8

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)

    width: parent.width > 450 ? 450 : parent.width
    margins: 10
    padding: 6

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    property int parentWidth: tooltip.parent.width
    property var value
    property bool containMinChars: value.length >= 8
    property bool containNumber: /^(?=.*[0-9])/.test(value)
    property bool containUpperLowerCase: /^(?=.*[a-z])(?=.*[A-Z])/.test(value)
    property bool containSpecialChars: /(?=.*[!@#\$%\^&\*\(\)\~\.\,])/.test(value)
    property bool secure: false
    property int validate: 0
    enum Color {
        Red = 2,
        Yellow,
        Green
    }

    function getColor () {
        switch (tooltip.validate) {
        case PasswordValidate.Color.Red: return UiKit.red
        case PasswordValidate.Color.Yellow: return UiKit.yellow
        case PasswordValidate.Color.Green: return UiKit.green
        default: return UiKit.red
        }
    }

    contentItem: Column {
        padding: 10
        spacing: 10

        RowLayout {
            width: parent.width - (parent.padding * 2)
            spacing: 10

            IconLabel {
                icon.color: tooltip.palette.text
                icon.name: tooltip.containMinChars ? "check-circle" : "warning"
                icon.width: 18
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                text: qsTr("8 characters minimum")
            }
        }

        RowLayout {
            width: parent.width - (parent.padding * 2)
            spacing: 10

            IconLabel {
                icon.color: tooltip.palette.text
                icon.name: tooltip.containUpperLowerCase ? "check-circle" : "warning"
                icon.width: 18
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                text: qsTr("Must contain uppercase and lowercase")
            }
        }

        RowLayout {
            width: parent.width - (parent.padding * 2)
            spacing: 10

            IconLabel {
                icon.color: tooltip.palette.text
                icon.name: tooltip.containNumber ? "check-circle" : "warning"
                icon.width: 18
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                text: qsTr("Must contain number")
            }
        }

        RowLayout {
            width: parent.width
            spacing: 10

            IconLabel {
                icon.color: tooltip.palette.text
                icon.name: tooltip.containSpecialChars ? "check-circle" : "warning"
                icon.width: 18
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                text: qsTr("Special characters \" ! @ # $% & * ( ) . , ~ \" increase security")
            }
        }


        ProgressBar {
            id: control

            width: parentWidth > 350 ? 330 : parent.width - (parent.padding * 2)
            value: tooltip.validatePassword()

            contentItem: Item {
                implicitWidth: 200
                implicitHeight: 4

                Rectangle {
                    width: control.visualPosition * parent.width
                    height: parent.height
                    radius: 4

                    color: tooltip.getColor()
                }
            }

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                y: (control.height - height) / 2
                height: 6

                color: control.palette.base
                radius: 4
            }
        }
    }

    background: Rectangle {
        id: rectangleBackground
        border.color: UiKit.border_color
        color: tooltip.palette.base
        radius: UiKit.radius
        opacity: 0.95

        Rectangle {
            visible: tooltip.background.visible
            width: 20
            height: 20
            rotation: tooltip.y < 0 ? 45 : -135

            y: tooltip.y < 0 ? tooltip.height - (height / 2) : -(height / 2)
            x: (width / 2) + 10

            color: "transparent"

            LinearGradient {
                width: parent.width
                height: parent.height

                start: Qt.point(0, 0)
                end: Qt.point(width / 2, width / 2)
                gradient: Gradient {
                    GradientStop {
                        color: "transparent"
                        position: 0
                    }
                    GradientStop {
                        color: tooltip.palette.base
                        position: 1
                    }
                }
            }

            Rectangle {
                height: parent.width
                width: 1
                anchors.right: parent.right
                color: UiKit.border_color
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                color: UiKit.border_color
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutQuad; duration: 100 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.InQuad; duration: 100 }
    }

    function validatePassword () {
        if (!tooltip.value)
            return 0

        let validates = 0
        if (tooltip.containUpperLowerCase) ++validates
        if (tooltip.containNumber) ++validates
        if (tooltip.containSpecialChars) ++ validates
        if (tooltip.containMinChars) ++validates

        tooltip.secure = (tooltip.containMinChars && validates >= 3)
        tooltip.validate = validates
        if (validates > 2 && !tooltip.containMinChars)
            tooltip.validate = validates - 1

        return validates / 4
    }
}
