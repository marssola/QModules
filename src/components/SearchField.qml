import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.impl 2.2

TextField {
    id: control

    property color backgroundColor: object.background_tabbar
    property color textColor: "#333"
    property color placeholderColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.3)

    padding: 5
    topPadding: 8
    bottomPadding: 8
    leftPadding: 10
    rightPadding: 50

    selectedTextColor: color
    verticalAlignment: TextInput.AlignVCenter
    selectByMouse: true

    color: textColor

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: control.placeholderColor
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            radius: 50
            color: control.backgroundColor
        }

        RoundButton {
            visible: control.text.length
            x: parent.width - width
            y: (parent.height /2) - (height /2)

            icon.name: "backspace"
            icon.width: 18
            icon.height: 18
            icon.color: control.placeholderColor
            flat: true

            background: Rectangle {
                color: "transparent"
            }

            onClicked: control.text = ""
        }
    }
}
