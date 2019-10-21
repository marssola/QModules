import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.impl 2.5
import QtQuick.Layouts 1.3

import UiKit 1.0

ItemDelegate {
    id: control

    property string title: text
    property var value

    contentItem: RowLayout {
        IconLabel {
            spacing: control.spacing
            mirrored: control.mirrored
            display: control.display
            alignment: control.display === IconLabel.IconOnly || control.display === IconLabel.TextUnderIcon ? Qt.AlignCenter : Qt.AlignLeft

            icon: control.icon
            font: control.font
            color: control.down || control.highlighted ? UiKit.white : control.palette.text

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        Label {
            Layout.fillWidth: true
            text: control.title

            font: control.font
            color: control.down || control.highlighted ? UiKit.white : control.palette.text
            elide: Label.ElideRight
        }

        Label {
            text: control.value
            font: control.font
            color: control.down || control.highlighted ? UiKit.white : UiKit.gray
            horizontalAlignment: Label.AlignRight
            elide: Label.ElideRight
        }
    }
}
