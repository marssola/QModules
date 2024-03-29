import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Layouts 1.12

import UiKit 1.0

Control {
    id: root

    width: parent.width
    implicitHeight: row.implicitHeight

    property var value
    property string label
    property string placeholderText
    property string icon
    property bool showIcon: true
    property bool showBorder: true
    property int columnLabelWidth: 130
    property int columnControlHeight
    property var control
    property string inputMask
    property int echoMode: TextField.Normal

    enum Item {
        TextField,
        TextArea,
        TimerField
    }

    RowLayout {
        id: row
        anchors.fill: parent

        RowLayout {
            visible: root.showIcon
            Layout.fillHeight: true
            Layout.maximumWidth: root.columnLabelWidth
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 15
            Layout.leftMargin: 10

            IconLabel {
                Layout.preferredWidth: 30
                display: IconLabel.IconOnly
                icon.name: root.icon
                icon.color: palette.text
            }

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: 5
                text: root.label
                elide: Label.ElideRight
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
               id: loaderControl
               width: parent.width
               height: parent.height

           }
        }
    }
    Rectangle {
        visible: showBorder
        width: parent.width
        height: 1
        color: UiKit.border_color

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.showIcon ? 50 : 0
    }

    Component {
        id: controlTextField

        TextField {
            id: textField
            height: root.columnControlHeight ? root.columnControlHeight : 48
            onTextChanged: root.value = text
            placeholderText: root.placeholderText
            verticalAlignment: TextInput.AlignVCenter

            inputMask: root.inputMask
            echoMode: root.echoMode

            padding: 6

            Component.onCompleted: {
                root.height = height
                if (root.value && textField.text !== root.value)
                    textField.text = root.value
            }
            Connections {
                target: root
                onValueChanged: {
                    if (root.value && textField.text !== root.value)
                        textField.text = root.value
                }
                onFocusChanged: if (root.focus) textField.forceActiveFocus()
            }
        }
    }
    Component {
        id: controlTextArea

        ScrollView {
            width: parent.width
            height: root.columnControlHeight ? root.columnControlHeight : 60
            clip: true

            T.TextArea {
                id: textArea
                placeholderText: root.placeholderText
                onTextChanged: root.value = text
                wrapMode: TextArea.WordWrap

                padding: 6
                color: textArea.palette.text
                selectionColor: textArea.palette.highlight
                selectedTextColor: textArea.palette.highlightedText

                PlaceholderText {
                    id: placeholder
                    x: textArea.leftPadding
                    y: textArea.topPadding
                    width: textArea.width - (textArea.leftPadding + textArea.rightPadding)
                    height: textArea.height - (textArea.topPadding + textArea.bottomPadding)

                    text: textArea.placeholderText
                    font: textArea.font
                    color: textArea.palette.text
                    opacity: 0.5
                    verticalAlignment: textArea.verticalAlignment
                    visible: !textArea.length && !textArea.preeditText && (!textArea.activeFocus || textArea.horizontalAlignment !== Qt.AlignHCenter)
                    elide: Text.ElideRight
                    wrapMode: Text.WordWrap
                    renderType: textArea.renderType
                }

                Component.onCompleted: {
                    root.height = height
                    if (root.value)
                        textArea.text = root.value
                }
                Connections {
                    target: root
                    onValueChanged: {
                        if (root.value && textArea.text !== root.value)
                            textArea.text = root.value
                    }
                    onFocusChanged: if (root.focus) textArea.forceActiveFocus()
                }
            }
        }
    }
    Component {
        id: controlTimer

        Item {
            width: parent.width
            height: root.columnControlHeight && root.columnControlHeight > 80 ? root.columnControlHeight : 80

            property int time: 0
            onTimeChanged: root.value = time

            function completeZero(str, length) {
                length = length ? length : 2
                str = str.toString()
                while (str.length < length)
                    str = "0" + str
                return str
            }
            function formatTime () {
                if (tumblerHours.currentItem && tumblerMinutes.currentItem && tumblerSeconds.currentItem)
                    time = (new Date(`1970-01-01 ${tumblerHours.currentItem.text}:${tumblerMinutes.currentItem.text}:${tumblerSeconds.currentItem.text}`).getTime() - (new Date().getTimezoneOffset() * 60 * 1000)) / 1000
            }
            function setTimeOnTumbler () {
                let t = new Date((time * 1000) + (new Date().getTimezoneOffset() * 60 * 1000))
                tumblerHours.currentIndex = t.getHours()
                tumblerMinutes.currentIndex = t.getMinutes()
                tumblerSeconds.currentIndex = t.getSeconds()
            }

            Component.onCompleted: {
                root.height = height
                if (root.value && time !== root.value) {
                    time = root.value
                    setTimeOnTumbler()
                }
            }
            Connections {
                target: root
                onValueChanged: {
                    if (root.value && time !== root.value) {
                        time = root.value
                        setTimeOnTumbler()
                    }
                }
            }

            Row {
                id: row
                anchors.fill: parent

                Tumbler {
                    id: tumblerHours
                    height: parent.height
                    model: 24
                    currentIndex: 0
                    delegate: Label {
                        text: completeZero(modelData, 2)
                        horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter
                        color: tumblerHours.visualFocus ? tumblerHours.palette.highlight : tumblerHours.palette.text

                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (tumblerHours.visibleItemCount / 2.1)
                    }

                    onCurrentIndexChanged: formatTime()
                }

                Label {
                    height: parent.height
                    verticalAlignment: Label.AlignVCenter
                    text: ":"
                    color: tumblerHours.palette.text
                }

                Tumbler {
                    id: tumblerMinutes
                    height: parent.height
                    model: 60
                    currentIndex: 0
                    delegate: Label {
                        text: completeZero(modelData, 2)
                        horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter
                        color: tumblerMinutes.visualFocus ? tumblerMinutes.palette.highlight : tumblerMinutes.palette.text

                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (tumblerMinutes.visibleItemCount / 2.1)
                    }

                    onCurrentIndexChanged: formatTime()
                }

                Label {
                    height: parent.height
                    verticalAlignment: Label.AlignVCenter
                    text: ":"
                    color: tumblerHours.palette.text
                }

                Tumbler {
                    id: tumblerSeconds
                    height: parent.height
                    model: 60
                    currentIndex: 0
                    delegate: Label {
                        text: completeZero(modelData, 2)
                        horizontalAlignment: Label.AlignHCenter
                        verticalAlignment: Label.AlignVCenter
                        color: tumblerSeconds.visualFocus ? tumblerSeconds.palette.highlight : tumblerSeconds.palette.text

                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (tumblerSeconds.visibleItemCount / 2.1)
                    }

                    onCurrentIndexChanged: formatTime()
                }
            }
        }
    }

    onControlChanged: {
        switch (control) {
            case 0: loaderControl.sourceComponent = controlTextField; break
            case 1: loaderControl.sourceComponent = controlTextArea; break
            case 2: loaderControl.sourceComponent = controlTimer; break
        }
    }
}

