import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Templates 2.12 as T
import UiKit 1.0

T.GroupBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitLabelWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 0

    topPadding: title ? 40 : 0

    label: Label {
        x: control.leftPadding
        width: control.availableWidth
        padding: 12

        text: control.title
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        font.bold: true
        font.pixelSize: control.font.pixelSize * 0.75
        font.capitalization: Font.AllUppercase
        opacity: 0.5
    }

    contentItem: Column {
        width: parent.width
    }

    background: Rectangle {
        y: control.topPadding
        width: parent.width
        height: parent.height - control.topPadding
        color: UiKit.popup_background

        Rectangle {
            width: parent.width
            height: 1
            color: UiKit.border_color
        }

        Rectangle {
            width: parent.width
            height: 1
            color: UiKit.border_color
            anchors.bottom: parent.bottom
        }
    }
}
